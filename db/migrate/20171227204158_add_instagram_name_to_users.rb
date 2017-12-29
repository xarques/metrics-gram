class AddInstagramNameToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :instagram_user, :string
  end
end
