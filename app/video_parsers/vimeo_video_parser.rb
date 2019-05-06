class VimeoVideoParser < VideoParser
  def self.parse(html)
    videos = []

    doc = Nokogiri::HTML(html)

    iframes = doc.css('iframe')

    iframes.each do |iframe|
      src = iframe.attr('src')

      if /player.vimeo.com/ =~ src

        parsed_uri = URI(src)
        parsed_uri.query = nil

        video = {
          src: parsed_uri.to_s,
          type: 'vimeo',
          fragment: iframe.to_html,
          tracks: false,
          properties: ''
        }

        videos << video
      end
    end

    return videos
  end

  # Perform additional processing on the video.
  def self.process(video:)
    # https://vimeo.com/api/v2/video/:video_id.json
    # https://player.vimeo.com/video/:video_id

    video.processing!

    # Grab the view count from this end point
    api_url = video.url.gsub(/player\.vimeo\.com(\/video\/\d+)/, 'vimeo.com/api/v2\1.json')

    begin
      response = HTTParty.get(api_url)
      response = JSON.parse(response.body)

      views = response.first["stats_number_of_plays"].to_i

      video.view_count = views

      response = HTTParty.get(video.url)
      html = response.body

      # The caption data is not available via the api but we can easily
      # grab it from the player configuration on the player page
      caption_regex = /var config.*?=(?<config>.*?);/

      languages = []

      if matches = html.match(caption_regex)
        config = JSON.parse(matches[:config])

        if config["request"].present? && config["request"]["text_tracks"].present?
          text_tracks = config["request"]["text_tracks"]

          video.captioned = text_tracks.present?

          video.properties = text_tracks.try(:join, ", ")
        end
      end
    rescue
      video.error!
    else
      video.processed!
    end
  end
end

