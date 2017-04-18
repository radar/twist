class Account < ApplicationRecord
  validates :subdomain, presence: true, uniqueness: true
  belongs_to :owner, class_name: "User"
  accepts_nested_attributes_for :owner
end
