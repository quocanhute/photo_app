class Vcomment < ApplicationRecord
  belongs_to :video
  belongs_to :user
  belongs_to :parent, class_name: 'Vcomment', optional: true
  has_many :vcomments, foreign_key: :parent_id, dependent: :destroy
  has_many :notifications, as: :object, dependent: :destroy

  acts_as_votable

  validates :content, presence: true, length: { maximum: 255 }

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

  def check_comment
    split_strings(self.content)
  end

  private
  # split string from fields in case it has multiple words
  def split_strings(string)
    string.split(' ').each do |s|
      bad = bad_word_list_check(s)
      if bad
        return bad
      end
    end
  end

  # checks if the word is in the bad word list
  def bad_word_list_check(word)
    BAD_WORDS.include?(word)
  end
end
