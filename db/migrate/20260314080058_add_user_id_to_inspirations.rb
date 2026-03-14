class AddUserIdToInspirations < ActiveRecord::Migration[7.1]
  def change
    add_column :inspirations, :user_id, :integer
  end
end
