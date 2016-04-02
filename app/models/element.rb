class Element < ActiveRecord::Base
  extend Processor

  belongs_to :chapter, touch: true
  has_many :notes

  delegate :book, to: :chapter
end
