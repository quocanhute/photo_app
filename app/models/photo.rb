class Photo < ApplicationRecord
  has_many :likeables,dependent: :destroy
  has_many :likes, through: :likeables, source: :user
  belongs_to :user

  after_create_commit do
    broadcast_new_photo
  end

  after_update_commit do
    broadcast_update_photo
  end

  after_destroy_commit do
    broadcast_destroy_photo
  end

  def broadcast_new_photo
    broadcast_prepend_later_to 'public_photos',
                               target: 'public_photos',
                               partial: 'photos/public_photo',
                               locals: { photo: self }
    broadcast_prepend_later_to 'private_photos',
                               target: 'private_photos',
                               partial: 'photos/private_photo',
                               locals: { photo: self, like_status: false }
  end

  def broadcast_update_photo
    shared_target_photo = "photo_#{id}"
    private_target_channel = "#{@user_gid} private_likes"
    broadcast_replace_later_to 'public_photos',
                               target: shared_target_photo,
                               partial: 'photos/public_photo',
                               locals: { photo: self }
    broadcast_replace_later_to 'private_photos',
                               target: shared_target_photo,
                               partial: 'photos/private_photo',
                               locals: { photo: self, like_status: false }
  end

  def broadcast_destroy_photo
    broadcast_remove_to 'public_photos',
                        target: "photo_#{id}"
    broadcast_remove_to 'private_photos',
                        target: "photo_#{id}"
  end
end
