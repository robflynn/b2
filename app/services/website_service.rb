class WebsiteService
    class << self
        def pageBatch(website:, params:) 
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


    end
end