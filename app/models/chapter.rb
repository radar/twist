class Chapter < ActiveRecord::Base
  def self.process!(book, file)
    book.chapters.create!(:title => "Testing")
  end
end
