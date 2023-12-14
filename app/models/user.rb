class User < ApplicationRecord
  # searchable do
  #   text :first_name
  #   text :last_name
  # end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable
  #acts as votable
  acts_as_voter
  has_rich_text :bio
  # Add the custom attribute
  enum role: { admin: 0, user: 1, censor: 2 }
  enum sex: { male: 0, female: 1 }
  has_one_attached :avatar
  # access the Relationship object
  has_many :followed_user, foreign_key: :follower_id, class_name: 'Relationship', dependent: :destroy
  has_many :followee, through: :followed_user, dependent: :destroy
  has_many :following_user, foreign_key: :followee_id, class_name: 'Relationship', dependent: :destroy
  has_many :follower, through: :following_user, dependent: :destroy
  # access the Notification object
  has_many :sent_notifications, class_name: 'Notification', foreign_key: 'sender_id'
  has_many :received_notifications, class_name: 'Notification', foreign_key: 'receiver_id'
  has_many :notifications, as: :object

  has_many :photos, dependent: :destroy
  has_many :albums, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy

  has_many :likeables, dependent: :destroy
  has_many :liked_photos, through: :likeables, source: :photo
  has_many :likeablealbums, dependent: :destroy
  has_many :liked_albums, through: :likeablealbums, source: :album
  has_many :user_tags, dependent: :destroy
  has_many :tags, through: :user_tags, source: :tag
  has_many :chats, dependent: :destroy

  validates :first_name, presence: true, length: { maximum: 25 }
  validates :last_name, presence: true, length: { maximum: 25 }
  validates :phone_number, presence: true
  validates :birthday, presence: true
  validates :address, presence: true


  def tag_added?(tag)
    tags.include?(tag)
  end

  def add_tag(tag)
    if tags.include?(tag)
      tags.destroy(tag)
    else
      tags << tag
    end
  end

  # ============================Photo==================================
  def liked?(photo)
    liked_photos.include?(photo)
  end
  def like(photo)
    if liked_photos.include?(photo)
      liked_photos.destroy(photo)
    else
      liked_photos << photo
    end
    public_target = "photo_#{photo.id}_public_likes"
    broadcast_replace_later_to 'public_likes',
                               target: public_target,
                               partial: 'likes/like_count',
                               locals: {photo: photo}
  end
    # ============================Album==================================
  def liked_album?(album)
    liked_albums.include?(album)
  end
  def like_album(album)
    if liked_albums.include?(album)
      liked_albums.destroy(album)
    else
      liked_albums << album
    end
    public_target = "album_#{album.id}_public_likes"
    broadcast_replace_later_to 'album_public_likes',
                               target: public_target,
                               partial: 'likes/like_count_album',
                               locals: {album: album}
  end
    # ==================================================================
  def username
    self.first_name + " " + self.last_name
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[confirmation_sent_at confirmation_token confirmed_at created_at email
      encrypted_password failed_attempts first_name id last_name locked_at remember_created_at
      reset_password_sent_at reset_password_token role unconfirmed_email unlock_token updated_at]
  end
  def self.ransackable_associations(auth_object = nil)
    %w[albums avatar_attachment avatar_blob comments followed_user followee follower following_user likeablealbums likeablecomments likeables liked_albums liked_comments liked_photos photos posts votes]
  end

end
