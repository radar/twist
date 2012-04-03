require 'spec_helper'

describe Book do
  context "upon creation" do
    let(:args) { ["radar", "rails3book_test"] }
    let(:git) { Git.new(*args) }

    before do
      # Ensure a pristine state
      Resque.remove_queue("normal")
      FileUtils.rm_r(git.path) if File.exist?(git.path)
      git.update!
      # We're really only wanting to test chapter processing here
      Book.any_instance.stub(:process_payload!)
    end

    it "enqueues a book for processing" do
      Resque.should_receive(:enqueue)
      book = Book.create(:title => "Rails 3 in Action", :path => "http://github.com/radar/rails3book_test")
      book.enqueue({})
      assert book.processing?
    end

    it "processes a test book" do
      # Should enqueue a job...
      book = Book.create(:title => "Rails 3 in Action (TESTs)", :path => "http://github.com/radar/rails3book_test")
      book.enqueue({})
      assert book.processing?
      # ... which when run ...
      run_resque_job!
      book.reload
      assert !book.processing?
      # ... creates a chapter!
      book.chapters.count.should eql(1)
    end
    
    it "processes the Rails 3 in Action real book" do
      # Should enqueue a job...
      book = Book.create(:title => "Rails 3 in Action", :path => "http://github.com/radar/rails3book")
      book.enqueue({})
      assert book.processing?
      # ... which when run ...
      run_resque_job!
      book.reload
      assert !book.processing?
      # ... creates a chapter!
      book.chapters.count.should eql(18)
      book.chapters.map(&:position).should == [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18]
    end
  end

  context "processing a payload" do
    let(:book) do
      Book.create(:title => "Rails 3 in Action (TESTs)", :path => "http://github.com/radar/rails3book_test")
    end

    it "triggers the processing of commits" do
      book.stub(:set_url!)
      Commit.should_receive(:process!).once
      book.process_payload!({ "commits" => [{ "message" => "Fixes #1" }]})
    end

  end
end
