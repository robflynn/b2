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

    # Now loop through each video and fire up a processing job
    page.videos.each do |video|
      # We'll pass the parser to the job as a string for now
      parser = VideoService.video_parser_for(video: video).to_s
      VideoProcessingJob.perform_later parser, video
    end
  end
end
