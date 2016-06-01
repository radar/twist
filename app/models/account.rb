class Account < ActiveRecord::Base
  validates :subdomain, presence: true, uniqueness: true
  belongs_to :owner, class_name: "User"
  accepts_nested_attributes_for :owner

  belongs_to :plan

  has_many :books
  has_many :invitations
  has_many :memberships
  has_many :users, through: :memberships

  def subscribed?
    braintree_subscription_id.present?
  end
end
