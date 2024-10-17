class User < ApplicationRecord
  has_secure_password
  has_many :sessions
  has_many :tweets

  validates :username, presence: true, uniqueness: true, length: { in: 3..64 }
  validates :email, presence: true, uniqueness: true, length: { in: 5..500 }
  validates :password, presence: true, length: { in: 8..64 }
end
