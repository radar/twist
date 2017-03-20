class Element < ActiveRecord::Base
  belongs_to :chapter
  has_many :notes

  delegate :book, to: :chapter
end
