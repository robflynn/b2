class CreateWebsites < ActiveRecord::Migration[5.2]
  def change
    create_table :websites do |t|
      t.string :domain
      t.string :name, null: false
      t.string :url, null: false
      t.integer :status, default: 0

      t.datetime :crawled_at
      t.datetime :processed_at
    end

    add_index :websites, :status
  end
end
