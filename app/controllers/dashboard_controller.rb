class DashboardController < ApplicationController
  PAGE_QUEUE_LIMIT = 50

  before_action :find_website

  def show
    # Get the pages currently being crawled or recently crawled
    @queue = WebsiteService.pages_being_crawled(website: @website).limit(PAGE_QUEUE_LIMIT)
  end

  def uncrawled
    @pages = Page.uncrawled.select(:id, :url).order(created_at: :asc)
  end

  def tester
    @pages = WebsiteService.pages_being_crawled(website: @website).select(:id, :status, :url)
  end

  def videos
    @videos = @website.videos.includes(:page_for_delegation)
  end

  private

  def find_website
    @website = Website.find_by(name: params[:name])
  end
end
