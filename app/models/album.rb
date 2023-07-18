class Album < ApplicationRecord
  has_many :likeablealbums, dependent: :destroy
  has_many :likes, through: :likeablealbums, source: :user
  belongs_to :user

  has_many_attached :images, dependent: :purge

  after_create_commit do
    broadcast_new_album
  end

  after_update_commit do
    broadcast_update_album
  end

  after_destroy_commit do
    broadcast_destroy_album
  end

  def broadcast_new_album
    broadcast_prepend_later_to 'public_albums',
                               target: 'public_albums',
                               partial: 'albums/public_album',
                               locals: { album: self }
    broadcast_prepend_later_to 'private_albums',
                               target: 'private_albums',
                               partial: 'albums/private_album',
                               locals: { album: self, album_like_status: false }
  end

  def broadcast_update_album
    shared_target_album = "album_#{id}"
    private_target_channel = "#{@user_gid} album_private_likes"
    broadcast_replace_later_to 'public_albums',
                               target: shared_target_album,
                               partial: 'albums/public_album',
                               locals: { album: self }
    broadcast_replace_later_to 'private_albums',
    # broadcast_replace_later_to private_target_channel,
                               target: shared_target_album,
                               partial: 'albums/private_album',
                               locals: { album: self, album_like_status: false }
  end

  def broadcast_destroy_album
    broadcast_remove_to 'public_albums',
                        target: "album_#{id}"
    broadcast_remove_to 'private_albums',
                        target: "album_#{id}"
  end
end
