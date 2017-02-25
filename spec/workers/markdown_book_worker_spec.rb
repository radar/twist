require "rails_helper"

describe MarkdownBookWorker do
  let(:book) { create_markdown_book! }

  it "processes a test Markdown book" do
    MarkdownBookWorker.new.perform(book.id)
    book.reload
    expect(book.chapters.count).to eq(4)

    intro = book.chapters.first
    expect(intro.file_name).to eq("introduction.markdown")
    expect(intro.permalink).to eq("introduction")
    expect(intro.position).to eq(1)
    expect(intro.part).to eq("frontmatter")

    chapter_1 = book.chapters.second
    expect(chapter_1.file_name).to eq("chapter_1/chapter_1.markdown")
    expect(chapter_1.permalink).to eq("in-the-beginning")
    expect(chapter_1.position).to eq(1)
    expect(chapter_1.part).to eq("mainmatter")

    appendix = book.chapters.third
    expect(appendix.file_name).to eq("chapter_2/chapter_2.markdown")
    expect(appendix.permalink).to eq("another-chapter")
    expect(appendix.position).to eq(2)
    expect(appendix.part).to eq("mainmatter")

    appendix = book.chapters.fourth
    expect(appendix.file_name).to eq("appendix.markdown")
    expect(appendix.permalink).to eq("appendix")
    expect(appendix.position).to eq(1)
    expect(appendix.part).to eq("backmatter")
  end
end
