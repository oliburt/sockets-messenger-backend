class AddCreatorIdToChatroom < ActiveRecord::Migration[6.0]
  def change
    add_column :chatrooms, :creator_id, :bigint
  end
end
