class CreateVcomments < ActiveRecord::Migration[7.0]
  def change
    create_table :vcomments do |t|
      t.text :content, null: false
      t.references :video, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
