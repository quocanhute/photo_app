class AddStatusToNotifications< ActiveRecord::Migration[7.0]
  def change
    add_column :notifications, :status, :integer, default: 0, null: false
  end
end
