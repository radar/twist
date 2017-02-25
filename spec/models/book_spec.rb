require 'rails_helper'

describe Book do
  let(:book) do
    create_markdown_book!
  end

  it "can be enqueued" do
    expect(MarkdownBookWorker).to receive(:perform_async).with(book.id.to_s)
    book.enqueue
  end
end
