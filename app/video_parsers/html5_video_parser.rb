class HTML5VideoParser < VideoParser
  def self.parse(content)
    videos = []

    doc = Nokogiri::HTML(content)

    video_tags = doc.css('video')

    video_tags.each do |video_tag|
      # If the video is autoplay/loop/muted then its probably just presentational
      # and we don't want to record it
      if !video_tag.attr('autoplay').nil? && !video_tag.attr('loop').nil? && !video_tag.attr('muted').nil?
        next
      end

      sources = video_tag.css('source')
      tracks = video_tag.css('track')

      video = {
        type: 'html5',
        fragment: video_tag.to_html,
        src: sources.map { |s| s.attr('src' ) }.join('\n'),
        properties: video_tag.attributes.keys.join(', '),
        tracks: tracks.any?
      }

      videos << video
    end

    return videos
  end
end