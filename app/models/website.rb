# == Schema Information
#
# Table name: websites
#
#  id           :integer          not null, primary key
#  name         :string(255)      not null
#  url          :string(255)      not null
#  status       :integer          default(0), not null
#  crawled_at   :datetime
#  processed_at :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  domain       :string(255)
#

class Website < ApplicationRecord
    # Define our statuses
    enum status: [:uncrawled, :crawling, :crawled, :processing, :processed]    
end
