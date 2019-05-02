module PageService
  class << self
    def process(page:)
      # Load the page if it was passed as an integer
      page = Page.find(page) if page.class == Integer

      videos = find_videos(page: page)
    end

    private

    def find_videos(page:)
      # Abort if there's no content type
      return [] if page.content_type.nil?

      # Abort if we're not working with html
      return [] unless page.content_type.include? "text/html"

      content = page.content

      videos = VideoService.find_videos(content)
    end
  end
end