class CreateVideos < ActiveRecord::Migration[5.2]
  def change
    create_table :videos do |t|
      t.references :page
      t.text :url
      t.string :embed_type

      t.text :fragment
      t.string :properties, limit: 1024
      t.boolean :captioned, default: false

      t.timestamps
    end

    add_index :videos, :embed_type
  end
end
