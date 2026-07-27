require 'feedjira'
require 'httparty'
require 'jekyll'
require 'nokogiri'
require 'time'
require 'digest'
require 'fileutils'
require 'json'

module ExternalPosts
  class ExternalPostsGenerator < Jekyll::Generator
    safe true
    priority :high

    def generate(site)
      if site.config['external_sources'] != nil
        site.config['external_sources'].each do |src|
          puts "Fetching external posts from #{src['name']}:"
          if src['rss_url']
            fetch_from_rss(site, src)
          elsif src['posts']
            fetch_from_urls(site, src)
          end
        end
      end
    end

    def fetch_from_rss(site, src)
      begin
        response = HTTParty.get(src['rss_url'], {
          timeout: 30,
          headers: {
            'User-Agent' => 'Mozilla/5.0 (compatible; Jekyll External Posts Plugin)'
          }
        })
        
        if response.success?
          xml = response.body
          return if xml.nil?
          feed = Feedjira.parse(xml)
          process_entries(site, src, feed.entries)
        else
          puts "Warning: Failed to fetch RSS from #{src['rss_url']} (Status: #{response.code})"
          return
        end
      rescue => e
        puts "Error fetching RSS from #{src['rss_url']}: #{e.message}"
        return
      end
    end

    def process_entries(site, src, entries)
      entries.each do |e|
        puts "...fetching #{e.url}"
        create_document(site, src['name'], e.url, {
          title: e.title,
          content: e.content,
          summary: e.summary,
          published: e.published
        })
      end
    end

    def create_document(site, source_name, url, content)
      # check if title is composed only of whitespace or foreign characters
      if content[:title].gsub(/[^\w]/, '').strip.empty?
        # use the source name and last url segment as fallback
        slug = "#{source_name.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')}-#{url.split('/').last}"
      else
        # parse title from the post or use the source name and last url segment as fallback
        slug = content[:title].downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
        slug = "#{source_name.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')}-#{url.split('/').last}" if slug.empty?
      end

      path = site.in_source_dir("_posts/#{slug}.md")
      doc = Jekyll::Document.new(
        path, { :site => site, :collection => site.collections['posts'] }
      )
      doc.data['external_source'] = source_name
      doc.data['title'] = content[:title]
      doc.data['feed_content'] = content[:content]
      doc.data['description'] = content[:summary]
      doc.data['date'] = content[:published]
      doc.data['redirect'] = url
      doc.data['tags'] = content[:tags] if content[:tags]
      doc.data['categories'] = content[:categories] if content[:categories]
      doc.data['word_count'] = content[:word_count] if content[:word_count]
      doc.content = content[:content]
      site.collections['posts'].docs << doc
    end

    def fetch_from_urls(site, src)
      data_file = site.in_source_dir("_data/fetched_posts.yml")
      unless File.exist?(data_file)
        puts "Warning: _data/fetched_posts.yml not found. Run bin/fetch_external_posts.rb to generate it."
        return
      end

      fetched_posts_data = YAML.load_file(data_file, permitted_classes: [Date, Time])['posts'].group_by { |p| p['url'] }

      src['posts'].each do |post_config|
        url = post_config['url']
        if fetched_posts_data.key?(url)
          post_data = fetched_posts_data[url].first
          puts "...loading pre-fetched content for #{url}"
          content = {
            title: post_data['title'],
            content: post_data['content'],
            summary: post_data['content'][0, 150] + '...',
            published: Time.parse(post_data['published_date'].to_s).utc,
            tags: post_config['tags'],
            categories: post_config['categories'],
            word_count: post_data['word_count']
          }
          create_document(site, src['name'], url, content)
        else
          puts "Warning: No pre-fetched data found for #{url} in _data/fetched_posts.yml"
        end
      end
    end

    def parse_published_date(published_date)
      case published_date
      when String
        Time.parse(published_date).utc
      when Date
        published_date.to_time.utc
      else
        raise "Invalid date format for #{published_date}"
      end
    end

    def fetch_content_from_url(url)
      # Check cache first
      cached_content = get_cached_content(url)
      return cached_content if cached_content
      
      retries = 0
      max_retries = 3
      
      begin
        response = HTTParty.get(url, {
          timeout: 30,
          headers: {
            'User-Agent' => 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36',
            'Accept' => 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8',
            'Accept-Language' => 'en-US,en;q=0.9',
            'Accept-Encoding' => 'gzip, deflate, br',
            'Connection' => 'keep-alive',
            'Upgrade-Insecure-Requests' => '1',
            'Cache-Control' => 'max-age=0'
          }
        })
        
        unless response.success?
          puts "Warning: Failed to fetch content from #{url} (Status: #{response.code})"
          return get_cached_content(url) || default_content(url)
        end
        
        html = response.body
        parsed_html = Nokogiri::HTML(html)

        # Enhanced title extraction for Substack and other platforms
        title = extract_title(parsed_html, url)
        description = extract_description(parsed_html)
        body_content = extract_body_content(parsed_html)

        content = {
          title: title,
          content: body_content,
          summary: description
        }
        
        # Cache successful fetch
        cache_content(url, content)
        content
        
      rescue Net::TimeoutError, Timeout::Error => e
        retries += 1
        if retries <= max_retries
          puts "Timeout fetching #{url}, retrying (#{retries}/#{max_retries})..."
          sleep(2 ** retries) # Exponential backoff
          retry
        else
          puts "Error: Timeout fetching content from #{url} after #{max_retries} retries"
          return get_cached_content(url) || default_content(url)
        end
      rescue => e
        puts "Error fetching content from #{url}: #{e.message}"
        return get_cached_content(url) || default_content(url)
      end
    end

    def cache_dir
      @cache_dir ||= File.join(Dir.tmpdir, 'jekyll_external_posts_cache')
    end

    def ensure_cache_dir
      FileUtils.mkdir_p(cache_dir) unless Dir.exist?(cache_dir)
    end

    def cache_file_path(url)
      File.join(cache_dir, "#{Digest::SHA256.hexdigest(url)}.json")
    end

    def cache_content(url, content)
      ensure_cache_dir
      cache_data = {
        content: content,
        timestamp: Time.now.to_i,
        url: url
      }
      
      begin
        File.write(cache_file_path(url), cache_data.to_json)
        puts "Cached content for #{url}"
      rescue => e
        puts "Warning: Failed to cache content for #{url}: #{e.message}"
      end
    end

    def get_cached_content(url)
      cache_file = cache_file_path(url)
      return nil unless File.exist?(cache_file)
      
      begin
        cache_data = JSON.parse(File.read(cache_file))
        # Cache expires after 24 hours
        if Time.now.to_i - cache_data['timestamp'] < 86400
          puts "Using cached content for #{url}"
          return symbolize_keys(cache_data['content'])
        else
          File.delete(cache_file) # Remove expired cache
          return nil
        end
      rescue => e
        puts "Warning: Failed to read cache for #{url}: #{e.message}"
        File.delete(cache_file) if File.exist?(cache_file) # Remove corrupted cache
        return nil
      end
    end

    def symbolize_keys(hash)
      hash.transform_keys(&:to_sym)
    end

    def extract_title(parsed_html, url)
      # Try multiple title extraction methods
      title = parsed_html.at('head meta[property="og:title"]')&.attr('content')
      title ||= parsed_html.at('head meta[name="twitter:title"]')&.attr('content')
      title ||= parsed_html.at('head title')&.text&.strip
      
      # Substack-specific selectors
      if url.include?('substack.com')
        title ||= parsed_html.at('.post-title')&.text&.strip
        title ||= parsed_html.at('h1.post-title')&.text&.strip
        title ||= parsed_html.at('[data-testid="post-title"]')&.text&.strip
        title ||= parsed_html.at('.pencraft.pc-display-font.pc-tracking-tight.pc-reset._color-pub-primary-text_3axnc_204._line-height-20_3axnc_95._font-meta_3axnc_131._size-11_3axnc_35._weight-medium_3axnc_162._transform-uppercase_3axnc_242._reset_3axnc_1')&.text&.strip
      end
      
      title ||= parsed_html.at('h1')&.text&.strip
      title ||= "External Post from #{URI.parse(url).host}"
      
      # Clean up title by removing site suffix
      title = title.split(' | ').first if title.include?(' | ')
      title = title.split(' - ').first if title.include?(' - ')
      title.strip
    end

    def extract_description(parsed_html)
      description = parsed_html.at('head meta[property="og:description"]')&.attr('content')
      description ||= parsed_html.at('head meta[name="twitter:description"]')&.attr('content')
      description ||= parsed_html.at('head meta[name="description"]')&.attr('content')
      description&.strip
    end

    def extract_body_content(parsed_html)
      # Try to find main content area first
      main_content = parsed_html.at('main, article, .post-content, .entry-content')
      
      # Substack-specific content selectors
      main_content ||= parsed_html.at('.available-content')
      main_content ||= parsed_html.at('.body.markup')
      main_content ||= parsed_html.at('[data-testid="post-content"]')
      
      if main_content
        body_content = main_content.search('p').map { |e| e.text }
      else
        body_content = parsed_html.search('p').map { |e| e.text }
      end
      
      # Clean and join content
      content_text = body_content.reject(&:empty?).join(' ').strip
      
      # If content is too short, try alternative extraction
      if content_text.length < 50
        content_text = parsed_html.search('div p, article p').map { |e| e.text }.reject(&:empty?).join(' ').strip
      end
      
      content_text
    end

    def default_content(url)
      {
        title: "External Post from #{URI.parse(url).host rescue 'External Source'}",
        content: "This is an external post. Click the link to read the full content.",
        summary: "External content from #{URI.parse(url).host rescue 'an external source'}."
      }
    end

  end
end
