require 'rails_helper'

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
      expect(BookWorker).to receive(:perform_async).with(book.id.to_s)
      expect(book.processing?).to eq(false)
      book.enqueue
      expect(book.processing?).to eq(true)
    end

    it "processes a test Markdown book" do
      BookWorker.new.perform(book.id)
      book.reload
      expect(book.chapters.count).to eq(1)
      expect(book.chapters.map(&:position)).to eq([1])
    end
  end
end
