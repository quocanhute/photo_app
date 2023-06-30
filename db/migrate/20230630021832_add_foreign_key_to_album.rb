class AddForeignKeyToAlbum < ActiveRecord::Migration[7.0]
  def change
    add_foreign_key :albums, :users
  end
end
