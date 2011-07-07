require 'spec_helper'

describe Book do

  context "upon creation" do
    it "enqueues a book for processing" do
      Resque.should_receive(:enqueue)
      Book.create(:title => "Rails 3 in Action", :path => "http://github.com/radar/rails3book_test")
    end

    it "processes a book" do
      # Should enqueue a job...
      book = Book.create(:title => "Rails 3 in Action", :path => "http://github.com/radar/rails3book_test")
      # ... which when run ...
      run_resque_job!
      # ... creates a chapter!
      book.chapters.count.should eql(1)
    end
  end
end