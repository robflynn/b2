class JWPlayerVideoParser < VideoParser
  def self.parse(html)
    videos = []

    # Define our own jwplayer function to intercept
    # the embedded javascript call
    function_template = <<-END
    function loader() {
    }

    loader.prototype.setup = function(json) {
      return json
    }

    function jwplayer(ele) {
      return new loader()
    }
    END

    doc = Nokogiri::HTML(html)

    regex = /jwplayer\(\w?['"]+?.*?['"]+?\w?\)\w?.setup\(.*?;/mi

    # Strip out any HTML comments
    sanitized_html = html.gsub(/<!--.*?-->/m, '')

    embeds = sanitized_html.scan(regex)

    embeds.each do |js|
      # Line ending in semicolon barfs with execjs
      sanitized_js = js.gsub(';', '')

      # Compile our custom jwplayer function
      custom_script = ExecJS.compile(function_template)

      # Get the result
      result = custom_script.eval(sanitized_js)

      # We only care about the URL
      if result["file"].present?
        video = {
          type: 'jwplayer',
          fragment: sanitized_js,
          src: result["file"],
          properties: '',
          tracks: false
        }

        videos << video
      end
    end

    return videos
  end
end