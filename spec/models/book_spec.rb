require 'spec_helper'

describe Book do
  context "upon creation" do
    let(:git) { Git.new("radar", "markdown_book_test") }

    let(:book) do
      Book.create(
        :title => "Markdown Book Test",
        :path => "http://github.com/radar/markdown_book_test"
      )
    end

    before do
      FileUtils.rm_r(git.path) if File.exist?(git.path)
      git.update!
    end

    it "enqueues" do
      BookWorker.should_receive(:perform_async).with(book.id.to_s)
      expect(book.processing?).to be_false
      book.enqueue
      expect(book.processing?).to be_true
    end

    it "processes a test Markdown book" do
      BookWorker.new.perform(book.id)
      book.reload
      book.chapters.count.should eql(1)
      book.chapters.map(&:position).should == [1]
    end
  end
end
