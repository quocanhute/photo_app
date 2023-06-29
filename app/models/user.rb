class User < ApplicationRecord
  validates :first_name, presence: true
  validates :last_name, presence: true
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  # Add the role attribute
  enum role: { admin: 0, user: 1 }
  def username
    if self.first_name && self.last_name
      self.first_name + " " + self.last_name
    else
      "Nothing"
    end
  end

  # access the Relationship object
  has_many :followed_user,
           foreign_key: :follower_id,
           class_name: 'Relationship',
           dependent: :destroy

  # access the user through the relationship object
  has_many :followee, through: :followed_user, dependent: :destroy

  # access the Relationship object
  has_many :following_user,
           foreign_key: :followee_id,
           class_name: 'Relationship',
           dependent: :destroy

  # access the user through the relationship object
  has_many :follower, through: :following_user, dependent: :destroy
end
