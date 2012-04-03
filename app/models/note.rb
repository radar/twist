class Note
  include Mongoid::Document
  include Mongoid::Timestamps
  field :text, :type => String
  # TODO: work out how to query for notes that have elements containing a specific id
  # This is used in notes/_button and feels hacky, which is a good sign that something is wrong
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
    state == "accepted" || state == "rejected" || state == "complete"
  end

  def expire_chapter_cache
    chapter.expire_cache
  end
end
