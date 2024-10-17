class Session < ApplicationRecord
  belongs_to :user

  before_validation :generate_token

  validates :user_id, presence: true

  private

  def generate_token
    self.token ||= SecureRandom.hex(20)
  end
end
