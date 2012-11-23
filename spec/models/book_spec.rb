require 'spec_helper'

describe Book do
  context "upon creation" do
    let(:git) { Git.new("radar", "rails3book_test") }

    before do
      # Ensure a pristine state
      Resque.remove_queue("normal")
      FileUtils.rm_r(git.path) if File.exist?(git.path)
      git.update!
    end

    it "enqueues a book for processing" do
      Resque.should_receive(:enqueue)
      book = Book.create(:title => "Rails 3 in Action", :path => "http://github.com/radar/rails3book_test")
      assert book.processing?
    end

    it "processes a test book" do
      # Should enqueue a job...
      book = Book.create(:title => "Rails 3 in Action (TESTs)", :path => "http://github.com/radar/rails3book_test")
      assert book.processing?
      Book.perform(book.id)
      book.reload
      assert !book.processing?
      # ... creates a chapter!
      book.chapters.count.should eql(1)
    end

    it "processes a test Markdown book" do
      # Should enqueue a job...
      book = Book.create(:title => "Markdown Book Test", :path => "http://github.com/radar/markdown_book_test")
      assert book.processing?
      # ... which when run ...
      Book.perform(book.id)
      book.reload
      assert !book.processing?
      # ... creates a chapter!
      book.chapters.count.should eql(1)
      book.chapters.map(&:position).should == [1]
    end
  end
end
