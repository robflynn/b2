class FixTimeColumnsOnPages < ActiveRecord::Migration[5.2]
  def up
    change_column :pages, :created_at, :datetime, null: true, default: nil
    change_column :pages, :updated_at, :datetime, null: true, default: nil
  end

  def down
  end
end
