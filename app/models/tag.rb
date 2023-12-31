class Tag < ActsAsTaggableOn::Tag
  # add the avatar attachment
  has_one_attached :tag_image

  has_many :user_tags,dependent: :destroy
  has_many :users, through: :user_tags, source: :user

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "detail", "id", "is_ban", "name", "taggings_count", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["tag_image_attachment", "tag_image_blob", "taggings", "user_tags", "users"]
  end

end