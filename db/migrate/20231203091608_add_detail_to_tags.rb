class AddDetailToTags < ActiveRecord::Migration[7.0]
  def change
    add_column :tags, :detail, :string
  end
end
