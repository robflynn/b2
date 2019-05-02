class AddStatusToVideos < ActiveRecord::Migration[5.2]
  def change
    add_column :videos, :status, :integer, default: 0
    add_index :videos, :status
  end
end
