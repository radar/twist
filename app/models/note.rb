class Note < ActiveRecord::Base
  belongs_to :element
  has_many :comments

  accepts_nested_attributes_for :comments

  delegate :chapter, to: :element

  after_save :expire_chapter_cache
  
  belongs_to :user
  
  def to_param
    number.to_s
  end
  
  def complete!
    self.state = "complete"
    self.save!
  end

  def accept!
    self.state = "accepted"
    self.save!
  end

  def reject!
    self.state = "rejected"
    self.save!
  end

  def reopen!
    self.state = "reopened"
    self.save!
  end

  def completed?
    ["accepted", "rejected", "complete"].include?(state)
  end

  def expire_chapter_cache
    chapter.expire_cache
  end
end
