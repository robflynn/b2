class VideoParser
  def self.parse(html)
    raise "Please inherit from and implement this class. It is not meant to use directly."
  end

  def self.process(video:)
    video.processing!
    video.processed!
  end
end