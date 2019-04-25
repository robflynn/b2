# == Schema Information
#
# Table name: videos
#
#  id         :bigint(8)        not null, primary key
#  page_id    :bigint(8)
#  url        :text
#  embed_type :string
#  fragment   :text
#  properties :string(1024)
#  captioned  :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_videos_on_embed_type  (embed_type)
#  index_videos_on_page_id     (page_id)
#

class Video < ApplicationRecord
  belongs_to :page

  delegate :title, :url, to: :page, prefix: true
end