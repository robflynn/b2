class YoutubeVideoParser < VideoParser
  def self.parse(html)
    videos = []

    videos = videos + parse_iframe_embed(html)
    videos = videos + parse_ytplayer_embed(html)

    return videos
  end

  def self.process(video:)
    video.processing!

    #video_id_regex = /^.*((youtu.be\/)|(v\/)|(\/u\/\w\/)|(embed\/)|(watch\?))\??v?=?(?<video_id>[^#\&\?]*).*/
    video_id_regex = /^.*(?:(?:youtu\.be\/|v\/|vi\/|u\/\w\/|embed\/)|(?:(?:watch)?\?v(?:i)?=|\&v(?:i)?=))(?<video_id>[^#\&\?]*).*/
    youtube_config_regex = /&player_response=(?<config>{.*?})&/

    begin
      api_base_url = "https://youtube.com/get_video_info?video_id="

      if matches = video.url.match(video_id_regex)
        video_id = matches[:video_id]
      else
        # We could not parse the id, get outta here
        raise "Could not parse youtube video_id"
      end

      api_url = "#{api_base_url}#{video_id}"

      response = HTTParty.get(api_url)
      data = CGI.unescape(response.body)

      languages = []

      if match = data.match(youtube_config_regex)
        config = JSON.parse(match[:config])

        if config['captions'].present? && config['captions']['playerCaptionsTracklistRenderer'].present? && config["captions"]["playerCaptionsTracklistRenderer"]["captionTracks"]
          config["captions"]["playerCaptionsTracklistRenderer"]["captionTracks"].each do |track|
            # We want to ignore asr tracks
            next if track["kind"].present? && track["kind"] == "asr"

            languages << track["languageCode"]

            video.captioned = true
          end # end loop
        end # end if track exist in json

        # Log the languages in the properties column
        video.properties = languages.join(', ')

        # Get the view count
        video.view_count = config["videoDetails"]["viewCount"].to_i
        video.channel_id = config["videoDetails"]["channelId"]
        video.channel_name = config["videoDetails"]["author"]
        video.duration = config["videoDetails"]["lengthSeconds"]
        video.title = config["videoDetails"]["title"]
        video.api_response = config.to_json
      else
        # We got here because the match failed, we couldn't get the youtube configuration
        puts "Could not load youtube configuration"
        raise "Could not load youtube configuration"
      end # end if match
    rescue => e
      # Some error occurred
      # puts "The API URL was:"
      # puts api_url
      # puts e.backtrace
      video.error!
    else
      # There were no errors, lets get out of here
      video.processed!
    end # end of begin block
  end # end process

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

