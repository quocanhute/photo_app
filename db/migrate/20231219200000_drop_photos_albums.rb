class DropPhotosAlbums < ActiveRecord::Migration[7.0]
  def change
    drop_table :likeables
    drop_table :likeablealbums
    drop_table :photos
    drop_table :albums
  end
end
