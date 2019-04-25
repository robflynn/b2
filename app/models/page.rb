# == Schema Information
#
# Table name: pages
#
#  id            :integer          not null, primary key
#  website_id    :integer
#  url           :string(4096)
#  title         :string(1024)
#  content_type  :string(255)
#  content       :text(4294967295)
#  response_code :integer
#  referrer      :string(4096)
#  status        :integer          default("uncrawled"), not null
#  visited_at    :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  message       :string(255)
#  digest        :string(64)
#
# Indexes
#
#  index_pages_on_digest                 (digest)
#  index_pages_on_website_id_and_status  (website_id,status)
#

class Page < ApplicationRecord
  enum status: [:uncrawled, :crawling, :crawled, :processing, :processed, :crawl_error, :unknown_type_error, :skipped]

  scope :visited,  -> { where(status: [:skipped, :crawl_error, :crawled]) }
  scope :not_visited, -> { where(status: [:uncrawled, :crawling]) }

  belongs_to :website

  #
  # Generate a SHA1 digest whenever the URL is changed
  #
  def url=(value)
    write_attribute(:url, value)

    self.digest = Digest::SHA1.hexdigest value
  end
end
