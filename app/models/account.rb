class Account < ApplicationRecord
  belongs_to :owner, class_name: "User"
  accepts_nested_attributes_for :owner
end
