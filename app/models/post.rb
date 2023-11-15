class Post < ApplicationRecord
  belongs_to :user
  has_many :elements, dependent: :destroy
  has_many :comments

  has_one_attached :header_image
end
