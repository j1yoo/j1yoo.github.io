#!/usr/bin/env ruby

require 'yaml'
require 'httparty'
require 'nokogiri'
require 'fileutils'
require 'date'

# Path to the configuration file
CONFIG_FILE = '/_config.yml'
# Path to the output data file
OUTPUT_FILE = '/_data/fetched_posts.yml'

# Function to fetch and parse content from a URL
def fetch_content_from_url(url)
  puts "Fetching: #{url}"
  begin
    response = HTTParty.get(url, {
      timeout: 30,
      headers: {
        'User-Agent' => 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36',
        'Accept' => 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8',
        'Accept-Language' => 'en-US,en;q=0.9',
        'Accept-Encoding' => 'gzip, deflate, br',
        'Connection' => 'keep-alive'
      }
    })

    unless response.success?
      puts "  \e[31mError: Failed to fetch content (Status: #{response.code})\e[0m"
      return nil
    end

    parsed_html = Nokogiri::HTML(response.body)

    # More robust title extraction
    title = parsed_html.at('head meta[property="og:title"]')&.attr('content')
    title ||= parsed_html.at('head meta[name="twitter:title"]')&.attr('content')
    title ||= parsed_html.at('h1.post-title')&.text
    title ||= parsed_html.at('[data-testid="post-title"]')&.text
    title ||= parsed_html.at('h1')&.text
    title ||= parsed_html.at('head title')&.text

    # More robust content extraction
    content_node = parsed_html.at('.available-content')
    content_node ||= parsed_html.at('article.post-content')
    content_node ||= parsed_html.at('[data-testid="post-content"]')
    content_node ||= parsed_html.at('article')
    
    content = content_node ? content_node.text : ""


    if title.nil? || title.strip.empty?
        puts "  \e[33mWarning: Could not extract title. Skipping.\e[0m"
        return nil
    end

    puts "  \e[32mSuccess: Fetched title - \"#{title.strip}\"\e[0m"

    text = content.strip
    {
      'title' => title.strip,
      # Keep only an excerpt: external posts may be third-party content, so the
      # full text must not be committed or republished. word_count preserves
      # the real length for the read-time display.
      'content' => text[0, 300],
      'word_count' => text.split(/\s+/).length
    }

  rescue => e
    puts "  \e[31mError: Exception while fetching - #{e.message}\e[0m"
    return nil
  end
end

# Main script execution
def main
  config_path = File.join(Dir.pwd, CONFIG_FILE)
  output_path = File.join(Dir.pwd, OUTPUT_FILE)

  unless File.exist?(config_path)
    puts "Error: _config.yml not found!"
    return
  end

  config = YAML.safe_load(File.read(config_path), permitted_classes: [Date, Time])
  external_sources = config['external_sources']

  unless external_sources
    puts "No external_sources found in _config.yml"
    return
  end

  fetched_data = {'posts' => []}

  external_sources.each do |source|
    next unless source['posts']
    source['posts'].each do |post_config|
      url = post_config['url']
      content = fetch_content_from_url(url)
      
      if content
        fetched_data['posts'] << {
          'url' => url,
          'published_date' => post_config['published_date'],
          'source_name' => source['name'],
          'title' => content['title'],
          'content' => content['content'],
          'word_count' => content['word_count']
        }
      end
    end
  end

  File.write(output_path, fetched_data.to_yaml)
  puts "\nSuccessfully fetched #{fetched_data['posts'].length} posts and saved to #{OUTPUT_FILE}"
end

main
