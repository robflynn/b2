require 'nokogiri'

class WebsiteService
  class InvalidURL < StandardError
    attr_reader :url

    def initialize(message = nil, url = nil)
      @url = url

      super(message)
    end
  end

  class << self
    def get_page_batch(website:, params:)
      return website.random_uncrawled_pages
    end

    def create(params:)
      return Website.transaction do
        website = Website.create!(
          params.require(:website).permit(:name, :url)
        )

        page = website.pages.build
        page.url = website.url
        page.save

        return website
        # transaction
      end

      return nil

      # create
    end

    def update_page(website:, params:)
      page = website.pages.find(params[:page_id])
      page.content_type = params[:content_type]
      page.response_code = params[:response_code]
      page.message = params[:message] if params[:message].present?

      # If there was an error crawling this page, log it
      if params[:error]
        page.crawl_error!
      else
        html = params[:content]

        page.content = html

        # Parse the page
        doc = Nokogiri::HTML(html, nil, 'UTF-8')

        # Get our links
        links = doc.xpath("//a/@href").map { |href| href.value.strip }

        links.each do |href|
          add_to_queue(website: website, url: href, referrer: page)
        end

        page.crawled!
      end

      return page
    end

  private

    # Add a page to the queue, checking it against the Website's filte rules
    def add_to_queue(website:, url:, referrer:)
      # Sanitize the URL
      s = build_page(website: website, url: url, referrer: referrer)
    end

    def build_page(website:, url:, referrer:)
      # Do nothing if the URL is empty
      return unless url.present?

      # Fix weird line breaks that some of the URLs have
      url = url.gsub("\n", "")
      url = url.gsub("\r", "")

      # Make sure the URI is parsable
      parsed_uri = Addressable::URI.parse(url)

      # Merge the URL with our referrer. This will fill in any
      # missing information (such as relative links)
      uri = Addressable::URI.join(referrer.url, parsed_uri)

      # Only support http and https schemes
      return unless uri.scheme == "http" || uri.scheme == "https"

      website_host = Addressable::URI.parse(website.url).host

      # Only allow children of the origin domain
      return unless uri.host.end_with? website_host

      puts "woozle3"
      # Don't crawl the following black listed extensions
      return unless crawlable_extension?(uri)

      # We don't wanna store fragments, so strip those off
      uri.fragment = nil

      # Reconstruct our URL, post-modifications
      url = uri.to_s

      # Build our page
      page = website.pages.build
      page.url = url
      page.referrer = referrer.url

      # We only want to store unique pages
      return unless unique_page?(page)

      # Cache the page for faster lookup
      cache_page(page)

      # Skip the page if it should be filtered. We still want
      # to write it to the database as it is a valid page and
      # the filter rules may be modified during a recrawl.
      page.status = :skipped if website.filters_url?(page.url)

      page.save!

      return page
    end

    def cache_page(page)
      # $mcache.set page.digest, 1
    end

    def crawlable_extension?(uri)
      blacklist = %w(
        .pdf .jpg .jpeg .gif .png .gifv .mp4 .mov .mpg .mpeg .mp3
        .xml .xslt .js .css .rss .zip .gz .tar.gz .rar .ics .avi
        .mkv .dat .sql .xslx .doc .xsl .docx .ppt .pptx .pps
      )

      ext = File.extname(uri.path).downcase

      # Don't load it if the extension is blacklisted
      return !blacklist.include?(ext)
    end

    def unique_page?(page)
      return !cache_key_exists?(page.digest)
    end

    def cache_key_exists?(key)
      #            DEBUG = true
      #            if DEBUG
      #                return Page.exists?(digest: key)
      #            end

      begin
        value = $mcache.get(key)
        return true
        rescue Memcached::NotFound => e
          return Page.exists?(digest: key)
      end
    end
  end
end
