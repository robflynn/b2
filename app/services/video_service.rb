module VideoService
  class << self
    def find_videos(html)
      videos = []

      video_parsers.each do |parser|
        chunks = parser.parse(html)

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

    def video_parsers
      [
        HTML5VideoParser,
        YoutubeVideoParser,
        VimeoVideoParser,
        JWVideoParser
      ]
    end
  end
end