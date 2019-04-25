class WebsitesController < ApplicationController
  before_action :find_website, only: [:queue, :update_page]

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
    batch = WebsiteService.get_page_batch(website: @website, params: params)

    if batch

      # Claim the batch
      batch.map(&:crawling!)

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

  def update_page
    render json: WebsiteService.update_page(website: @website, params: params)
  end

    private

  def find_website
    @website = Website.find(params[:id])
  end
end
