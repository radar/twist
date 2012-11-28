class Note
  include Mongoid::Document
  include Mongoid::Timestamps
  field :text, :type => String
  field :element_id, :type => String
  field :number, :type => Integer
  field :state, :type => String, :default => "new"
  
  embeds_one :element
  embedded_in :chapter
  
  embeds_many :comments

  after_save :expire_chapter_cache
  
  belongs_to :user
  
  def to_param
    number.to_s
  end
  
  def complete!
    self.state = "complete"
    self.save
  end

  def accept!
    self.state = "accepted"
    self.save
  end

  def reject!
    self.state = "rejected"
    self.save
  end

  def reopen!
    self.state = "reopened"
    self.save
  end

  def completed?
    ["accepted", "rejected", "complete"].include?(state)
  end

  def expire_chapter_cache
    chapter.expire_cache
  end
end
