class Invitation < ActiveRecord::Base
  belongs_to :account

  validates :email, presence: true
end
