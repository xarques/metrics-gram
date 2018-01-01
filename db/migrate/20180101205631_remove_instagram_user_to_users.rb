class RemoveInstagramUserToUsers < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :instagram_user, :string
  end
end
