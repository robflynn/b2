class WebsiteService
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
                # Otherwise, parse the page and mark it crawled
                # PageParser.parse(page)            
                page.crawled!
            end

            return page
        end
    end
end