class Account < ActiveRecord::Base
  belongs_to :owner, class_name: "User"
  accepts_nested_attributes_for :owner

  validates :subdomain, presence: true, uniqueness: true
end
