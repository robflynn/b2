# == Schema Information
#
# Table name: websites
#
#  id           :bigint(8)        not null, primary key
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

  def random_uncrawled_pages(page_count = 10)
    sql = "SELECT id FROM (SELECT id FROM pages WHERE status=0 AND website_id=#{self.id} ORDER BY RANDOM() LIMIT #{page_count}) t"

    ids = ActiveRecord::Base.connection.select_all(sql)

    ids = ids.map { |i| i["id"] }

    self.pages.where(id: ids)
  end

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

  def page_queue
    queue = self.pages.where.not(status: :uncrawled).where('updated_at >= ?', 10.minute.ago)
  end

end
