class CreatePages < ActiveRecord::Migration[5.2]
  def change
    create_table :pages do |t|
      t.integer :website_id
      t.string :url, limit: 4096
      t.string :title, limit: 1024
      t.string :content_type
      t.text :content
      t.integer :response_code
      t.string :referrer, limit: 4096
      t.integer :status, default: 0

      t.datetime :visited_at

      t.string :message

      t.string :digest, limit: 64
    end

    add_index :pages, [:website_id, :status]
    add_index :pages, :digest
  end
end
