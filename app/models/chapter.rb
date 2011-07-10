class Chapter < ActiveRecord::Base
  has_many :elements, :as => :parent, :extend => Processor
  has_many :sections
end
