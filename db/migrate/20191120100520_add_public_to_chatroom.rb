class AddPublicToChatroom < ActiveRecord::Migration[6.0]
  def change
    add_column :chatrooms, :pulic, :boolean
  end
end
