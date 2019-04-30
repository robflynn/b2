class DashboardController < ApplicationController
  PAGE_QUEUE_LIMIT = 25

  def show
    @website = Website.find_by(name: params[:name])

    # Get the pages currently being crawled or recently crawled
    @queue = @website.page_queue.order('updated_at desc, status').limit(PAGE_QUEUE_LIMIT)
  end
end
