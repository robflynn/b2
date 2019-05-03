class VideoProcessingJob < ApplicationJob
  queue_as :default

  def perform(parser, video)
    video_parser = parser.constantize

    video_parser.process(video: video)
  end
end
