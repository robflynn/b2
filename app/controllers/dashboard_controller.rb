class DashboardController < ApplicationController
  PAGE_QUEUE_LIMIT = 25

  before_action :find_website

  def show
    # Get the pages currently being crawled or recently crawled
    @queue = @website.page_queue.order('updated_at desc, status').limit(PAGE_QUEUE_LIMIT)
  end

  def uncrawled
    @pages = Page.uncrawled.select(:id, :url).order(created_at: :asc)
  end

  def tester
    @pages = WebsiteService.pages_being_crawled(website: @website).limit(25)
  end

  private

  def find_website
    @website = Website.find_by(name: params[:name])
  end
end
