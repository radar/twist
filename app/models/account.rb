class Account < ActiveRecord::Base
  belongs_to :owner, class_name: "User"
  accepts_nested_attributes_for :owner

  belongs_to :plan

  validates :subdomain, presence: true, uniqueness: true

  has_many :invitations
  has_many :subscription_events

  has_and_belongs_to_many :users

  has_many :books

  def subscribed?
    braintree_subscription_id.present?
  end

  def over_limit_for?(plan)
    books.count > plan.books_allowed
  end
end
