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
end