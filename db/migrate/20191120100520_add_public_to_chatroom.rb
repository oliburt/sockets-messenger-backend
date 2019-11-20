class AddPublicToChatroom < ActiveRecord::Migration[6.0]
  def change
    add_column :chatrooms, :public, :boolean
  end
end
