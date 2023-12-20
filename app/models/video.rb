class Video < ApplicationRecord
  
  belongs_to :user
  has_one_attached :header_image, dependent: :destroy
  has_one_attached :video, dependent: :destroy
  has_many :vcomments, dependent: :destroy
  has_many :tags
  has_many :notifications, as: :object, dependent: :destroy

  acts_as_votable
  acts_as_taggable_on :tags

  validates :title, presence: true, length: { maximum: 100 }
  validates :description, presence: true, length: { maximum: 255 }
  validates :header_image, presence: true
  validates :video, presence: true

  def bookmark!(user)
    if user.voted_up_on? self, vote_scope: "bookmark"
      unvote_by user, vote_scope: "bookmark"
    else
      upvote_by user, vote_scope: "bookmark"
    end
  end

  def upvote!(user)
    if user.voted_up_on? self, vote_scope: "like"
      unvote_by user, vote_scope: "like"
    else
      upvote_by user, vote_scope: "like"
    end
  end

  def downvote!(user)
    if user.voted_down_on? self, vote_scope: "like"
      unvote_by user, vote_scope: "like"
    else
      downvote_by user, vote_scope: "like"
    end
  end

  def self.bookmarked_by_user(user)
    joins(:votes_for)
      .where(votes: { voter_id: user.id, vote_scope: 'bookmark', votable_type: 'Video' })
  end
end