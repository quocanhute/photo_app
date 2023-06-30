class AddUserToAlbums < ActiveRecord::Migration[7.0]
  def change
      add_reference :albums, :user
  end
end
