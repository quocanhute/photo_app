class User < ApplicationRecord
  validates :first_name, presence: true, length: { maximum: 25 }
  validates :last_name, presence: true, length: { maximum: 25 }
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable
  #acts as votable
  acts_as_voter
  # notifications
  has_many :notifications, as: :recipient, dependent: :destroy
  # Add the custom attribute
  enum role: { admin: 0, user: 1, censor: 2 }
  has_one_attached :avatar
  # access the Relationship object
  has_many :followed_user, foreign_key: :follower_id, class_name: 'Relationship', dependent: :destroy
  # access the user through the relationship object
  has_many :followee, through: :followed_user, dependent: :destroy
  # access the Relationship object
  has_many :following_user, foreign_key: :followee_id, class_name: 'Relationship', dependent: :destroy
  # access the user through the relationship object
  has_many :follower, through: :following_user, dependent: :destroy
  has_many :photos, dependent: :destroy
  has_many :albums, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy

  has_many :likeables, dependent: :destroy
  has_many :liked_photos, through: :likeables, source: :photo
  has_many :likeablealbums, dependent: :destroy
  has_many :liked_albums, through: :likeablealbums, source: :album
  has_many :likeablecomments, dependent: :destroy
  has_many :liked_comments, through: :likeablecomments, source: :comment
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
  def liked_comment?(comment)
    liked_comments.include?(comment)
  end
  def like_comment(comment)
    if liked_comments.include?(comment)
      liked_comments.destroy(comment)
    else
      liked_comments << comment
    end
    public_target = "comment_#{comment.id}_public_likes"
    broadcast_replace_later_to 'comment_public_likes',
                               target: public_target,
                               partial: 'likes/like_count_comment',
                               locals: {comment: comment}
  end
  def username
    if self.first_name && self.last_name
      self.first_name + " " + self.last_name
    else
      "Nothing"
    end
  end
end
