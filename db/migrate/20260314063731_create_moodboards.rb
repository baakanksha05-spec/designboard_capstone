class CreateMoodboards < ActiveRecord::Migration[7.1]
  def change
    create_table :moodboards do |t|
      t.text :vibe_sentence
      t.text :ai_data_json

      t.timestamps
    end
  end
end
