require 'rails_helper'

describe Book do

  context "a markdown book" do
    let(:book) do
      create_markdown_book!
    end

    it "can be enqueued" do
      expect(MarkdownBookWorker).to receive(:perform_async).with(book.id.to_s)
      book.enqueue
    end
  end

  context "an asciidoc book" do
    let(:book) do
      create_asciidoc_book!
    end

    it "can be enqueued" do
      expect(AsciidocBookWorker).to receive(:perform_async).with(book.id.to_s)
      book.enqueue
    end
  end
end
