# == Schema Information
#
# Table name: page_filters
#
#  id          :bigint(8)        not null, primary key
#  website_id  :bigint(8)
#  filter      :string(255)      not null
#  filter_type :string(255)      default("regex"), not null
#  note        :string(255)
#
# Indexes
#
#  index_page_filters_on_website_id                  (website_id)
#  index_page_filters_on_website_id_and_filter_type  (website_id,filter_type)
#

class PageFilter < ApplicationRecord
end
