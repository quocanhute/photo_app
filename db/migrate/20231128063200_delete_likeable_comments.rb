class DeleteLikeableComments < ActiveRecord::Migration[7.0]
  def change
    drop_table :likeablecomments
  end
end