class Invitation < ApplicationRecord
  belongs_to :account

  validates :email, presence: true
end
