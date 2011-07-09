require 'spec_helper'

describe Chapter do
  let(:git) { Git.new("radar", "rails3book_test") }
  let(:book) { Factory(:book) }

  before do
    # Nuke the repo, start afresh.
    FileUtils.rm_r(git.path)
    git.update!
  end

  it "processes a chapter" do
    book.chapters.process!(git, "ch01/ch01.xml")
    book.chapters.first.title.should eql("Ruby on Rails, the framework")
  end
end