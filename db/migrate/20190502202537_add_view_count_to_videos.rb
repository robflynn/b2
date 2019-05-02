class AddViewCountToVideos < ActiveRecord::Migration[5.2]
  def change
    add_column :videos, :view_count, :integer
  end
end
