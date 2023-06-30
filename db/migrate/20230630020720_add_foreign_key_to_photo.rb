class AddForeignKeyToPhoto < ActiveRecord::Migration[7.0]
  def change
    add_foreign_key :photos, :users
  end
end
