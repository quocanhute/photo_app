class Tag < ActsAsTaggableOn::Tag
  # add the avatar attachment
  has_one_attached :tag_image
  has_many :posts

  has_many :user_tags,dependent: :destroy
  has_many :users, through: :user_tags, source: :user
end