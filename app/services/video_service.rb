module VideoService
  class << self
    def find_videos(html)
      videos = []

      video_processors.each do |processor|
        chunks = processor.parse(html)

        chunks.each do |chunk|
          video = Video.new
          video.url =  chunk[:src]
          video.embed_type = chunk[:src]
          video.fragment = chunk[:fragment]
          video.captioned = chunk[:tracks]
          video.properties = chunk[:properties]

          videos << video
        end
      end

      return videos
    end

    private

    def video_processors
      [
        HTML5VideoParser
      ]
    end
  end
end