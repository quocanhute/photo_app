class Tag < ActsAsTaggableOn::Tag
  # add the avatar attachment
  has_one_attached :tag_image
  has_many :posts

end