# == Schema Information
#
# Table name: videos
#
#  id         :bigint           not null, primary key
#  page_id    :bigint
#  url        :text
#  embed_type :string
#  fragment   :text
#  properties :string(1024)
#  captioned  :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  view_count :integer
#  status     :integer          default({:unprocessed=>"unprocessed", :processing=>"processing", :processed=>"processed"})
#
# Indexes
#
#  index_videos_on_embed_type  (embed_type)
#  index_videos_on_page_id     (page_id)
#  index_videos_on_status      (status)
#

class Video < ApplicationRecord
  enum status: [
    :unprocessed,
    :processing,
    :processed
  ]

  belongs_to :page
  belongs_to :page_for_delegation, -> { select [:id, :url, :title] }, :class_name => "Page", foreign_key: :page_id

  delegate :title, :url, to: :page_for_delegation, prefix: :page

  def needs_processing?
    return false unless self.unprocessed?

    # We can fetch view counts and captioning info
    # from youtube and vimeo
    return true if self.embed_type == "youtube"
    return true if self.embed_type == "vimeo"

    false
  end
end
