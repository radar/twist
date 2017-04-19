class Invitation < ActiveRecord::Base
  belongs_to :account

  before_create :generate_token

  validates :email, presence: true

  def to_param
    token
  end

  private

  def generate_token
    self.token = SecureRandom.hex(16)
  end
end
