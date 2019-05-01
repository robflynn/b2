class OpenCoursewareVideoParser < VideoParser
  def self.parse(html)
    videos = []

    # Stub out the open courseware embed functions
    function_template = <<-END
    function ocw_embed_chapter_media(container_id, media_url, provider, page_url, image_url, start, stop, captions_file) {
      return {
        "container_id": container_id,
        "media_url": media_url,
        "provider": provider,
        "page_url": page_url,
        "image_url": image_url,
        "captions_file": captions_file
      }
    }

    function ocw_embed_media(container_id, media_url, provider, page_url, image_url, captions_file) {
      return {
        "container_id": container_id,
        "media_url": media_url,
        "provider": provider,
        "page_url": page_url,
        "image_url": image_url,
        "captions_file": captions_file
      }
    }
    END

    regex = /ocw_embed_chapter_media\(.*?\)/mix

    # Find all of the ocw embeds on the page
    embeds = html.scan(regex)

    # Compile our custom function
    custom_script = ExecJS.compile(function_template)

    embeds.each do |js|
      # Line ending in semicolon barfs with execjs
      sanitized_js = js.gsub(';', '')

      # Get the result
      result = custom_script.eval(sanitized_js)

      # We only care about the URL
      if result["media_url"].present?

        media_url = result["media_url"]

        # Some of the youtube media urls are a bit wonky
        # and use the old flash-based embed style. Lets
        # correct those just to make them easier for us to
        # spot check
        media_url.gsub(/youtube.com\/v\/(.*?)/, 'youtube.com/watch?v=\1')

        video = {
          type: result["provider"],
          fragment: sanitized_js,
          src: media_url,
          properties: '',
          tracks: result["captions_file"].present?
        }

        videos << video
      end
    end

    return videos
  end
end