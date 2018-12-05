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

                # Parse the page
                doc = Nokogiri::HTML(html, nil, 'UTF-8')

				# Get our links
				links = doc.xpath("//a/@href").map { |href| href.value.strip }

				links.each do |href|
					add_to_queue(website: website, url: href, referrer: page)
				end

                # page.crawled!
            end

            return page
        end

        private

        # Add a page to the queue, checking it against the Website's filte rules
        def add_to_queue(website:, url:, referrer:)
        	# Sanitize the URL
        	url = sanitize_url(url, referrer: referrer)
        end

        def sanitize_url(url, referrer:)
			# Do nothing if the URL is empty
			raise InvalidURL.new("URL Not Found", url) unless url.present?

			# Fix weird line breaks that some of the URLs have
			url = url.gsub("\n", "")
			url = url.gsub("\r", "")

			# Make sure the URI is parsable
			parsed_uri = Addressable::URI.parse(url)

			# Merge the URL with our referrer. This will fill in any
			# missing information (such as relative links)
			uri = Addressable::URI.join(referrer.url, parsed_uri)

			validate_scheme(uri)
        end

        def validate_scheme(uri)
        	raise InvalidURL.new("Only http and https schemes are supported") unless uri.scheme == "http" || uri.scheme == "https2"
        end

    end
end
