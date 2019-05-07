class AddChannelUrlToVideos < ActiveRecord::Migration[5.2]
  def change
    add_column :videos, :channel_url, :string
  end
end
