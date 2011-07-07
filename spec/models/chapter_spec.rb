require 'spec_helper'

describe Chapter do
  let(:git) { Git.new("radar", "rails3book_test") }
  let(:book) { Factory(:book) }
  it "processes a chapter" do
    Chapter.process!(book, git.path + "ch01/ch01.xml")
    book.chapters.first.title.should eql("Ruby on Rails, the framework")
  end
end