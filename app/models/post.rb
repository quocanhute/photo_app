class Post < ApplicationRecord
  belongs_to :user
  has_many :elements

  has_one_attached :header_image
end
