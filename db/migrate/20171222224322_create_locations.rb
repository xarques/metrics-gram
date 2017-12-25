class CreateLocations < ActiveRecord::Migration[5.1]
  def change
    create_table :locations do |t|
      t.string :city, null: false, unique: true
      t.integer :instagram_id, null: false, unique: true

      t.timestamps
    end
  end
end
