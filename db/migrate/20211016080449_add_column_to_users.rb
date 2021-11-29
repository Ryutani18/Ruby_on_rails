class AddColumnToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :image_name, :string
    add_column :users, :password, :string
  end
end
