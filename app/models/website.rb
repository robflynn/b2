# == Schema Information
#
# Table name: websites
#
#  id           :integer          not null, primary key
#  name         :string(255)      not null
#  url          :string(255)      not null
#  status       :integer          default("uncrawled"), not null
#  crawled_at   :datetime
#  processed_at :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  domain       :string(255)
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
end
