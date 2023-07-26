class SetDefaultIsPublicForPhotoAndAlbum < ActiveRecord::Migration[7.0]
  def change
    change_column_default :photos, :is_public, false
    change_column_default :albums, :is_public, false
  end
end
