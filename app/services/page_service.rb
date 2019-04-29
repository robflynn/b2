module PageService
  class << self
    def process(page:)
      #page.processing!

      videos = find_videos(page: page)

      #page.processed!
    end

    private

    def find_videos(page: page)
      # Abort if there's no content type
      return [] if page.content_type.nil?

      # Abort if we're not working with html
      return [] unless page.content_type.include? "text/html"

      content = page.content

      videos = VideoService.find_videos(content)
    end

    def video_processors
      []
    end
  end
end