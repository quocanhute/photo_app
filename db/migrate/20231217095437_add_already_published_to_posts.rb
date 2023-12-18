class AddAlreadyPublishedToPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :already_published, :boolean, default: false
  end
end
