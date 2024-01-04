class Tweet < ApplicationRecord
    validates :username, presence: true, length: { minimum: 3, maximum: 64 }
    validates :message, presence: true, length: { maximum: 140 }
    
end
