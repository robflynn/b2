class YoutubeVideoParser < VideoParser
  def self.parse(html)
    videos = []

    videos = videos + parse_iframe_embed(html)
    videos = videos + parse_ytplayer_embed(html)

    return videos
  end

  private

  def self.parse_iframe_embed(html)
    videos = []

    doc = Nokogiri::HTML(html)

    iframes = doc.css('iframe')
    iframes.each do |iframe|
      src = iframe.attr('src')

      if /youtube.com\/embed.*?/ =~ src
        parsed_uri = URI(src)
        parsed_uri.query = nil

        video = {
          src: parsed_uri.to_s,
          type: 'youtube',
          fragment: iframe.to_html,
          properties: '',
          tracks: false
        }

        videos << video
      end
    end

    return videos
  end

  def self.parse_ytplayer_embed(html)
    videos = []

    # Stub out the open courseware embed functions
    function_template = <<-END
    var YT = {}

    YT.Player = function(ele, options) {
      return options
    }
    END

    regex = /YT.Player\(.*?}\)/mix

    # Find all of the ocw embeds on the page
    embeds = html.scan(regex)

    # Compile our custom function
    custom_script = ExecJS.compile(function_template)

    embeds.each do |js|
      # Line ending in semicolon barfs with execjs
      sanitized_js = js.gsub(';', '')

      # Get the result
      result = custom_script.eval(sanitized_js)

      video = {
        src: "https://youtube.com/watch/v?=#{result["videoId"]}",
        type: 'youtube',
        fragment: sanitized_js,
        properties: result["playerVars"],
        tracks: false
      }

      videos << video
    end

    return videos
  end
end

