class CreateNotificationsV2 < ActiveRecord::Migration[7.0]
  def change
    create_table :notifications do |t|
      t.references :sender, references: :users, null: false, foreign_key: { to_table: :users }
      t.references :receiver, references: :users, null: false, foreign_key: { to_table: :users }
      t.references :object, polymorphic: true, null: false
      t.text :content
      t.boolean :as_read
      t.datetime :read_at

      t.timestamps
    end
  end
end
