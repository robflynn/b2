# == Schema Information
#
# Table name: page_filters
#
#  id          :bigint(8)        not null, primary key
#  website_id  :bigint(8)
#  filter      :string           not null
#  filter_type :string           default("regex")
#  note        :string
#
# Indexes
#
#  index_page_filters_on_website_id                  (website_id)
#  index_page_filters_on_website_id_and_filter_type  (website_id,filter_type)
#

class PageFilter < ApplicationRecord
	enum filter_type: {
		regex: 'regex',
		literal: 'literal'
  }

  def to_regex
    filter.to_regexp(literal: literal?)
  end
end
