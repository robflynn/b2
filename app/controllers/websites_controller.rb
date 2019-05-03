class WebsitesController < APIController
  before_action :set_json_response_type
  before_action :find_website, only: [:queue, :update_page, :get_stats, :get_queue]

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
      }, status: :bad_request
    end
  end

  def queue
    batch = WebsiteService.get_page_batch(website: @website, params: params)
                          .select(:website_id, :id, :status, :url)

    if batch
      batch.update_all(status: :crawling, updated_at: Time.now)

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
    page = WebsiteService.update_page(website: @website, params: params)

    if Page.where(id: page.id).containing_video.count > 0
      PageProcessingJob.perform_later(page)
    end

    render json: page
  end

  def get_queue
    @queue = WebsiteService.pages_being_crawled(website: @website).select(:id, :url, :status)

    render json: @queue
  end

  def get_stats
    pages_per_second = WebsiteService.pages_per_period(website: @website)

    crawled_pages = @website.total_pages_crawled
    total_pages = @website.pages.count

    @stats = {
      crawled_pages: crawled_pages,
      total_pages: total_pages,
      percent: @website.percent_crawled,
      pages_per_second: pages_per_second.round(2),
      time_remaining: WebsiteService.crawl_time_remaining(website: @website),
      crawl_status: pages_per_second == 0 ? "stopped" : "crawling",
      num_videos: @website.videos.processed.count,
      num_videos_pending: @website.videos.pending.count,
      jobs: Delayed::Job.count
    }

    render json: @stats
  end

    private

  def find_website
    @website = Website.find(params[:id])
  end

  def set_json_response_type
    response.content_type = Mime[:json]
  end


end
