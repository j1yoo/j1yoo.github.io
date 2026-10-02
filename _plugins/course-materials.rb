# Course materials and large site downloads use a fresh manifest to verify both the origin and its mirror.
require 'digest'
require 'json'
require 'nokogiri'
require 'open3'
require 'time'
require 'uri'

module Jekyll
  module CourseMaterials
    SOURCE_DIRECTORIES = %w[assets/courses/pba assets/courses/eci].freeze
    MIRROR_LIMIT = 20_000_000
    # Other tracked downloads directly inside an assets/ folder use the loader only when it helps:
    # below 1 MB GitHub Pages is fast enough, and the mirror refuses files above MIRROR_LIMIT.
    SITE_FILE = %r{\Aassets/[A-Za-z0-9_-]+/[^/]+\.(pdf|pptx|ppt|docx|doc|xlsx|zip|r|rmd|qmd|ipynb)\z}i.freeze
    SITE_MIN_BYTES = 1_000_000
    # The deploy regenerates the CV after the build, so CV files and the CV pages always stay direct.
    CV_NAME = /\Acv|resume/i.freeze
    LOADER_URL = '/teaching/material/'.freeze
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
        course_files = SOURCE_DIRECTORIES.flat_map { |directory| Dir.glob(File.join(site.source, directory, '**', '*')).sort }.select do |file|
          File.file?(file) && File.extname(file).match?(/\A\.(pdf|r)\z/i)
        end
        tracked_assets = (git(site, 'ls-files', '-z', '--', 'assets') || '').force_encoding(Encoding::UTF_8).split("\0").sort
        site_files = tracked_assets.map { |path| File.join(site.source, path) }.select do |file|
          File.file?(file) && CourseMaterials.site_file?(file.delete_prefix("#{site.source}/"), File.size(file))
        end
        materials = {}
        (course_files + site_files).each do |file|
          relative_path = file.delete_prefix("#{site.source}/")
          path = "/#{relative_path}"
          source = File.binread(file)
          materials[path] = {
            'path' => path,
            'filename' => File.basename(file),
            'bytes' => source.bytesize,
            'sha256' => Digest::SHA256.hexdigest(source),
            'mime' => mime(file),
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

      def mime(file)
        case File.extname(file).downcase
        when '.pdf' then 'application/pdf'
        when '.r', '.rmd', '.qmd' then 'text/plain'
        else 'application/octet-stream'
        end
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

    def self.site_file?(path, bytes)
      path.match?(SITE_FILE) && !File.basename(path).match?(CV_NAME) && bytes.between?(SITE_MIN_BYTES, MIRROR_LIMIT)
    end

    def self.rewrite_links(document)
      return unless Jekyll::Page::HTML_EXTENSIONS.include?(document.output_ext) && document.output.is_a?(String)
      # The loader's no-script list must stay direct, and so must the CV pages: /cv_print/ is printed to the CV PDF.
      return if document.url == LOADER_URL || document.url.split('/').reject(&:empty?).first.to_s.match?(CV_NAME)

      materials = document.site.config['course_materials']
      return unless materials

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
        anchor['href'] = "#{baseurl}#{LOADER_URL}?#{URI.encode_www_form(params)}"
        anchor['data-material-path'] = source[:path]
        # A download attribute would save the loader page itself instead of opening it.
        anchor.remove_attribute('download')
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
      return nil unless path.start_with?('/assets/')

      { path: path, query: uri.query, fragment: uri.fragment }
    rescue URI::InvalidURIError
      nil
    end
  end
end

Jekyll::Hooks.register [:pages, :documents], :post_render do |document|
  Jekyll::CourseMaterials.rewrite_links(document)
end
