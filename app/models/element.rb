class Element < ActiveRecord::Base
  has_many :versions, :class_name => "ElementVersion" 
  
  before_update :track_old_version
  
  private
    def track_old_version
      versions.create!(:tag => self.tag, :content => self.content_was, :number => self.current_version)
      self.current_version += 1
    end
end
