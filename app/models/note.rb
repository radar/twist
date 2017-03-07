class Note < ActiveRecord::Base
  belongs_to :element, counter_cache: true, touch: true
  has_many :comments

  accepts_nested_attributes_for :comments

  delegate :chapter, to: :element

  belongs_to :user

  def to_param
    number.to_s
  end

  def accept!
    self.state = "accepted"
    self.save!
  end

  def reject!
    self.state = "rejected"
    self.save!
  end

  def open!
    self.state = "open"
    self.save!
  end

  def completed?
    ["accepted", "rejected"].include?(state)
  end
end
