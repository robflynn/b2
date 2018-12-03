class WebsitesController < ApplicationController
    before_action :find_website, only: [:queue]

  def index
    render json: Website.all
  end

  def create
    website = WebsiteService.create(params: params)

    if website
        render json: website
    else
        render json: { 
                        success: false, 
                        message: "Could not create message" 
                     },                      
                     status: :bad_request
    end
  end

  def queue
    batch = WebsiteService.pageBatch(website: @website, params: params)

    if batch
        render json: {
            pages: batch,
            stats: {
                pages: @website.pages.count,
                visited: @website.pages.visited.count,
                not_visited: @website.pages.not_visited.count,
            }
        }
    else            
        render json: { success: false, message: "There was an error retrieving the batch." }
    end
  end

    private

    def find_website
        @website = Website.find(params[:id])
    end    

end
