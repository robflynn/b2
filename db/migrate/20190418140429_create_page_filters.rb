class CreatePageFilters < ActiveRecord::Migration[5.2]
  def change
    create_table :page_filters do |t|
      t.bigint :website_id
      t.string :filter, null: false
      t.string :filter_type, default: "regex"
      t.string :note
    end

    add_index :page_filters, [:website_id, :filter_type]
    add_index :page_filters, :website_id
  end
end
