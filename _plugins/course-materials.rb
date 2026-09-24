# PBA downloads use a fresh manifest to verify both the origin and its mirror.
require 'digest'
require 'json'
require 'nokogiri'
require 'open3'
require 'time'
require 'uri'

module Jekyll
  module CourseMaterials
    SOURCE_DIRECTORY = 'assets/courses/pba'.freeze
    MIRROR_LIMIT = 20_000_000
    MIRROR_BASE = 'https://gcore.jsdelivr.net/gh/j1yoo/j1yoo.github.io'.freeze
    COMMIT_PATTERN = /\A[0-9a-f]{40}\z/.freeze
    # Parse just anchor opening tags; leave the document, comments, and raw-text
    # elements byte-for-byte intact instead of serializing the whole page.
    HTML_TOKENS = /<!--.*?-->|<(script|style|textarea|title)\b(?:[^>"']|"[^"]*"|'[^']*')*>.*?<\/\1\s*>|<a\b(?:[^>"']|"[^"]*"|'[^']*')*>/im.freeze

    class ManifestPage < Jekyll::PageWithoutAFile
      def initialize(site, manifest)
        super(site, site.source, 'assets/data', 'course-materials.json')
        self.content = JSON.generate(manifest)
        self.data = { 'layout' => nil, 'sitemap' => false, 'nav' => false }
      end

      def render_with_liquid?
        false
      end
    end

    class Generator < Jekyll::Generator
      safe true
      priority :low

      def generate(site)
        revision = git(site, 'rev-parse', 'HEAD')&.strip
        unless revision&.match?(COMMIT_PATTERN)
          raise Jekyll::Errors::FatalException, 'Course materials require a Git checkout with a valid HEAD.'
        end

        repository_prefix = git(site, 'rev-parse', '--show-prefix').to_s.strip
        materials = {}
        Dir.glob(File.join(site.source, SOURCE_DIRECTORY, '**', '*')).sort.each do |file|
          next unless File.file?(file) && File.extname(file).match?(/\A\.(pdf|r)\z/i)

          relative_path = file.delete_prefix("#{site.source}/")
          path = "/#{relative_path}"
          source = File.binread(file)
          materials[path] = {
            'path' => path,
            'filename' => File.basename(file),
            'bytes' => source.bytesize,
            'sha256' => Digest::SHA256.hexdigest(source),
            'mime' => File.extname(file).casecmp('.pdf').zero? ? 'application/pdf' : 'text/plain',
            'mirror_url' => mirror_url(site, relative_path, repository_prefix, revision, source)
          }
        end

        manifest = {
          'schema' => 1,
          'generated_at' => Time.now.utc.iso8601,
          'revision' => revision,
          'materials' => materials
        }
        site.config['course_materials'] = materials
        site.config['course_materials_manifest'] = manifest
        site.pages.reject! { |page| page.is_a?(ManifestPage) }
        site.pages << ManifestPage.new(site, manifest)
      end

      private

      def git(site, *arguments)
        executable = File.executable?('/opt/homebrew/bin/git') ? '/opt/homebrew/bin/git' : 'git'
        output, status = Open3.capture2(executable, '-C', site.source, *arguments, err: File::NULL, binmode: true)
        status.success? ? output : nil
      rescue Errno::ENOENT
        nil
      end

      def mirror_url(site, path, repository_prefix, revision, source)
        return nil if source.bytesize > MIRROR_LIMIT

        # In a shallow checkout, log resolves to the available boundary commit;
        # its tree still contains the file's exact version. HEAD is a safe fallback
        # only when its blob also matches the bytes published by this build.
        commit = git(site, 'log', '-1', '--format=%H', '--', path)&.strip
        commit = revision unless commit&.match?(COMMIT_PATTERN)
        committed_source = git(site, 'show', "#{commit}:#{repository_prefix}#{path}")
        return nil unless committed_source == source

        escaped_path = path.split('/').map { |part| URI.encode_www_form_component(part).gsub('+', '%20') }.join('/')
        "#{MIRROR_BASE}@#{commit}/#{escaped_path}"
      end
    end

    def self.rewrite_links(document)
      return unless document.data['layout'] == 'course-eci'

      materials = document.site.config['course_materials']
      return unless materials && document.output.is_a?(String)

      document.output = document.output.gsub(HTML_TOKENS) do |token|
        next token unless token.match?(/\A<a\b/i)

        anchor = Nokogiri::HTML.fragment("#{token}</a>").at_css('a')
        next token unless anchor && anchor['href']

        source = source_url(anchor['href'], document.site)
        next token unless source && materials.key?(source[:path])

        params = { 'file' => source[:path] }
        params['source_query'] = source[:query] if source[:query] && !source[:query].empty?
        params['fragment'] = source[:fragment] if source[:fragment] && !source[:fragment].empty?
        baseurl = document.site.config['baseurl'].to_s.sub(%r{/\z}, '')
        anchor['href'] = "#{baseurl}/teaching/material/?#{URI.encode_www_form(params)}"
        anchor['data-material-path'] = source[:path]
        anchor.remove_attribute('download') if File.extname(source[:path]).casecmp('.r').zero?
        anchor.to_html.sub(%r{</a>\z}, '')
      end
    end

    def self.source_url(href, site)
      uri = URI.parse(href)
      if uri.host
        origin = URI.parse(site.config['url'].to_s)
        return nil unless uri.userinfo.nil? && uri.host == origin.host
        return nil unless uri.scheme.nil? || (uri.scheme == origin.scheme && uri.port == origin.port)
        return nil if uri.scheme.nil? && uri.port && uri.port != origin.port
      else
        return nil unless uri.scheme.nil? && href.start_with?('/') && !href.start_with?('//')
      end

      path = URI::DEFAULT_PARSER.unescape(uri.path)
      baseurl = site.config['baseurl'].to_s.sub(%r{/\z}, '')
      path = path.delete_prefix(baseurl) if !baseurl.empty? && path.start_with?("#{baseurl}/")
      return nil unless path.start_with?("/#{SOURCE_DIRECTORY}/")

      { path: path, query: uri.query, fragment: uri.fragment }
    rescue URI::InvalidURIError
      nil
    end
  end
end

Jekyll::Hooks.register [:pages, :documents], :post_render do |document|
  Jekyll::CourseMaterials.rewrite_links(document)
end
