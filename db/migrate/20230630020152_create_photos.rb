class CreatePhotos < ActiveRecord::Migration[7.0]
  def change
    create_table :photos do |t|
      t.string :title
      t.string :url
      t.text :description
      t.boolean :is_public

      t.timestamps
    end
  end
end
