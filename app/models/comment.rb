class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user
  belongs_to :parent, class_name: 'Comment', optional: true
  has_many :comments, foreign_key: :parent_id
  has_many :likeablecomments, dependent: :destroy
  has_many :liked_user, through: :likeablecomments, source: :user
end
