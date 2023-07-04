class Photo < ApplicationRecord
  has_many :likeables,dependent: :destroy
  has_many :likes, through: :likeables, source: :user
  belongs_to :user

  after_create_commit do
    broadcast_new_photo
  end

  def broadcast_new_photo
    broadcast_prepend_later_to 'public_photos',
                               target: 'public_photos',
                               partial: 'photos/public_photo',
                               locals: { photo: self }
    # broadcast_prepend_later_to 'private_tweets',
    #                            target: 'private_tweets',
    #                            partial: 'tweets/private_tweet',
    #                            locals: { tweet: self, like_status: false }
  end
end
