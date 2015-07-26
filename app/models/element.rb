class Element < ActiveRecord::Base
  extend Processor

  belongs_to :chapter
  has_many :notes

  delegate :book, to: :chapter
end
