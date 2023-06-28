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
end
