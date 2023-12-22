class AddIsBanToPostsAndVideosAndTagsAndUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :is_ban, :boolean, default: false
    add_column :videos, :is_ban, :boolean, default: false
    add_column :tags, :is_ban, :boolean, default: false
    add_column :users, :is_ban, :boolean, default: false
  end
end
