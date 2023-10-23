class AddSortToElements < ActiveRecord::Migration[7.0]
  def change
    add_column :elements, :sort, :integer
  end
end
