class Account < ActiveRecord::Base
  belongs_to :owner, class_name: "User"
  accepts_nested_attributes_for :owner

  validates :subdomain, presence: true, uniqueness: true

  has_many :invitations

  has_many :memberships
  has_many :users, through: :memberships

  def create_schema
    Apartment::Tenant.create(subdomain)
  end
end
