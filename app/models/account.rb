class Account < ActiveRecord::Base
  belongs_to :plan
  belongs_to :owner, class_name: "User"
  accepts_nested_attributes_for :owner

  validates :subdomain, presence: true, uniqueness: true

  has_many :invitations

  has_and_belongs_to_many :users

  has_many :books
end
