class AddActiveUserToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :active_user, :boolean
  end
end
