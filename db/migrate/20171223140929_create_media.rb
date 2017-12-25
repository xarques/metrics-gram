class CreateMedia < ActiveRecord::Migration[5.1]
  def change
    create_table :media do |t|
      t.string :shortcode
      t.date :taken_at_timestamp
      t.string :display_url

      t.timestamps
    end
  end
end
