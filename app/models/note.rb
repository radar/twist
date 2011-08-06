class Note
  include Mongoid::Document
  field :text, :type => String
  # TODO: work out how to query for notes that have elements containing a specific id
  # This is used in notes/_button and feels hacky, which is a good sign that something is wrong
  field :element_identifier, :type => String
  field :number, :type => Integer
  field :state, :type => String, :default => "new"
  
  embeds_one :element
  embedded_in :chapter
  
  embeds_many :comments
  
  belongs_to :user
  
  def to_param
    number.to_s
  end
  
  def complete!
    self.state = "complete"
    self.save
  end
  
  def reopen!
    self.state = "reopened"
    self.save
  end
end