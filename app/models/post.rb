class Post < ApplicationRecord

  belongs_to :user
  has_one_attached :header_image
  has_many :elements, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :tags
  has_many :notifications, as: :object, dependent: :destroy

  acts_as_votable
  acts_as_taggable_on :tags

  enum status: { un_status: 0, in_queue: 1, accept: 2, refuse: 3 }

  validates :title, presence: true, length: { maximum: 100 }
  validates :description, presence: true
  validates :header_image, presence: true

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
      .where(votes: { voter_id: user.id, vote_scope: 'bookmark', votable_type: 'Post' })
  end

  def self.ransackable_attributes(auth_object = nil)
    ["already_published", "cached_scoped_bookmark_votes_down", "cached_scoped_bookmark_votes_score", "cached_scoped_bookmark_votes_total", "cached_scoped_bookmark_votes_up", "cached_scoped_like_votes_down", "cached_scoped_like_votes_score", "cached_scoped_like_votes_total", "cached_scoped_like_votes_up", "cached_weighted_bookmark_average", "cached_weighted_bookmark_score", "cached_weighted_bookmark_total", "cached_weighted_like_average", "cached_weighted_like_score", "cached_weighted_like_total", "created_at", "description", "id", "published", "published_at", "title", "updated_at", "user_id"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["base_tags", "commented_users", "comments", "elements", "header_image_attachment", "header_image_blob", "notifications", "tag_taggings", "taggings", "tags", "user", "votes_for"]
  end
end
