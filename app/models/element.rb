class Element < ActiveRecord::Base
  # A parent can be one of a Chapter or a Section.
  belongs_to :parent, :polymorphic => true
  has_many :versions, :class_name => "ElementVersion"
  has_many :children, :as => :parent, :class_name => "Element"

  
  before_update :track_old_version
  
  private
    def track_old_version
      versions.create!(:tag => self.tag, :content => self.content_was, :number => self.current_version)
      self.current_version += 1
    end
end
