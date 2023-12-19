class CreateVideos < ActiveRecord::Migration[7.0]
  def change
    create_table :videos do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.boolean :published, default: false
      t.datetime :published_at
      t.references :user, null: false, foreign_key: true
      t.boolean :already_published, default: false

      t.timestamps
    end
  end
end
