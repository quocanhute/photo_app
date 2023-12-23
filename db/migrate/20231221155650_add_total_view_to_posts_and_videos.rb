class AddTotalViewToPostsAndVideos < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :total_views, :integer, default: 0, null: false
    add_column :videos, :total_views, :integer, default: 0, null: false

  end
end
