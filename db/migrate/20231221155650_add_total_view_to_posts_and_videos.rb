class AddTotalViewToPostsAndVideos < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :total_views, :integer
    add_column :videos, :total_views, :integer

  end
end
