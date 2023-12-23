class AddStatusToPostsAndVideos < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :status, :boolean, default: 0
    add_column :videos, :status, :boolean, default: 0
  end
end
