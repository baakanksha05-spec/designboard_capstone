class CreateInspirations < ActiveRecord::Migration[7.1]
  def change
    create_table :inspirations do |t|
      t.string :image_path
      t.text :notes
      t.text :ai_data_json
      t.integer :user_id

      t.timestamps
    end
  end
end
