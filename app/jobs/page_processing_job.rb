class PageProcessingJob < ApplicationJob
  queue_as :default

  def perform(page)
    page.processing!

    videos = PageService.process(page: page)

    # Delete any videos the page currently has
    page.videos.destroy_all

    videos.each do |video|
      page.videos << video
    end

    page.processed!
  end
end
