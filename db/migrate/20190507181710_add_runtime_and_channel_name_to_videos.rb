class AddRuntimeAndChannelNameToVideos < ActiveRecord::Migration[5.2]
  def change
    add_column :videos, :title, :string
    add_column :videos, :duration, :integer
    add_column :videos, :channel_name, :string
    add_column :videos, :channel_id, :string
    add_column :videos, :api_response, :text
  end
end
