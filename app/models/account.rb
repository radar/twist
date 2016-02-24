class Account < ActiveRecord::Base
  belongs_to :owner, class_name: "User"
  belongs_to :plan
  accepts_nested_attributes_for :owner

  validates :subdomain, presence: true, uniqueness: true

  has_many :invitations
  has_many :memberships
  has_many :users, through: :memberships
  has_many :books
end
