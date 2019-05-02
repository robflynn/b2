# == Schema Information
#
# Table name: websites
#
#  id           :bigint           not null, primary key
#  domain       :string
#  name         :string           not null
#  url          :string           not null
#  status       :integer          default("uncrawled")
#  crawled_at   :datetime
#  processed_at :datetime
#
# Indexes
#
#  index_websites_on_status  (status)
#

class Website < ApplicationRecord
  # Define our statuses
  enum status: [:uncrawled, :crawling, :crawled, :processing, :processed]

  has_many :pages
  has_many :filters, class_name: 'PageFilter'
  has_many :videos, through: :pages

  validates_uniqueness_of :name, :url

  def filters_url?(url)
    filters_regexp.match?(url)
  end

  def filters_regexp
    @filters_regexp ||= Regexp.union(filters.map(&:to_regex))
  end

  def percent_crawled
  	crawled_pages = total_pages_crawled
  	total_pages = pages.count

    percent = ((crawled_pages.to_f / total_pages) * 100.0).round(4)
  end

  def total_pages_crawled
    checked_status = [:crawled, :skipped, :crawl_error]
    pages.where(status: checked_status).count
  end

  def apply_filters!
    ids = pages.uncrawled.select(:id,:url).select { |url| self.filters_url? url.url }.map(&:id)
    pages.where(id: ids).update_all(status: :skipped, updated_at: DateTime.now)
  end
end
