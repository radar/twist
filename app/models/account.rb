class Account < ActiveRecord::Base
  validates :subdomain, presence: true, uniqueness: true
  belongs_to :owner, class_name: "User"
  accepts_nested_attributes_for :owner

  has_many :invitations
  has_many :memberships
  has_many :users, through: :memberships
end
