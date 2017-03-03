require "rails_helper"

describe AsciidocChapterProcessor do
  let(:book) { create_asciidoc_book! }
  let(:chapter) { book.chapters.create(title: "Test Chapter") }
  let(:element) do
    build_chapter_element <<-HTML
      #{content}
    HTML
  end
  subject { AsciidocChapterProcessor.new(chapter, element) }

  def build_chapter_element(tags)
    Nokogiri::HTML.parse(<<-HTML
      <div class="sect1">
        #{tags}
      </div>
    HTML
    ).css(".sect1")
  end

  context "h2" do
    let(:content) { %Q{<h2 id="_chapter_1">1. Chapter 1</h2>} }

    it "adds a h2 element to the chapter" do
      subject.process
      element = chapter.elements.find_by(tag: "h2")
      expect(element.content).to eq(content)
    end
  end

  context "table" do
    let(:content) do
      <<-HTML.strip
      <table>
        <tr>
          <td>A table.</td>
        </tr>
      </table>
      HTML
    end

    it "adds the table element to the chapter" do
      subject.process
      element = chapter.elements.find_by(tag: "table")
      expect(element.content).to eq(content)
    end
  end

  context "div.paragraph" do
    let(:content) { %Q{<div class="paragraph"><p>Simple paragraph</p></div>} }

    it "adds a h2 element to the chapter" do
      subject.process
      element = chapter.elements.find_by(tag: "p")
      expect(element.content).to eq("<p>Simple paragraph</p>")
    end
  end

  context "div.listingblock" do
    let(:content) do
      <<-HTML.strip
        <div class="listingblock">
        <div class="title">book.rb</div>
        <div class="content">
        <pre class="highlight"><code class="language-ruby" data-lang="ruby">class Book
          attr_reader :title

          def initialize(title)
            @title = title
          end
        end</code></pre>
        </div>
      </div>
      HTML
    end

    it "adds the listingblock element to the chapter" do
      subject.process
      element = chapter.elements.find_by(tag: "div")
      expect(element.content).to eq(content)
    end
  end

  context "div.imageblock" do
    let(:content) do
      <<-HTML.strip
      <div class="imageblock">
        <div class="content">
          <img src="ch01/images/welcome_aboard.png" alt="welcome aboard">
        </div>
      </div>
      HTML
    end

    it "adds the imageblock element to the chapter" do
      subject.process
      element = chapter.elements.find_by(tag: "div")
      expect(element.content).to eq(content)
    end
  end

  context "div.sect2 w/ h3 & div.para" do
    let(:content) do
      <<-HTML
      <div class="sect2">
        <h3>Sect2 title</h3>
        <div class="paragraph">
          <p>Simple para inside of a sect2</p>
        </div>
      </div>
      HTML
    end

    it "adds the admonitionblock element to the chapter" do
      subject.process

      h3_element = chapter.elements.find_by(tag: "h3")
      expect(h3_element.content).to eq("<h3>Sect2 title</h3>")


      para_element = chapter.elements.find_by(tag: "p")
      expect(para_element.content).to eq("<p>Simple para inside of a sect2</p>")
    end
  end

  context "div.sect3 w/ h4 & div.para" do
    let(:content) do
      <<-HTML
      <div class="sect3">
        <h4>Sect3 title</h4>
        <div class="paragraph">
          <p>Simple para inside of a sect3</p>
        </div>
      </div>
      HTML
    end

    it "adds the admonitionblock element to the chapter" do
      subject.process

      h3_element = chapter.elements.find_by(tag: "h4")
      expect(h3_element.content).to eq("<h4>Sect3 title</h4>")


      para_element = chapter.elements.find_by(tag: "p")
      expect(para_element.content).to eq("<p>Simple para inside of a sect3</p>")
    end
  end

  context "div.sect4 w/ h5 & div.para" do
    let(:content) do
      <<-HTML
      <div class="sect4">
        <h5>Sect4 title</h5>
        <div class="paragraph">
          <p>Simple para inside of a sect4</p>
        </div>
      </div>
      HTML
    end

    it "adds the admonitionblock element to the chapter" do
      subject.process

      h3_element = chapter.elements.find_by(tag: "h5")
      expect(h3_element.content).to eq("<h5>Sect4 title</h5>")


      para_element = chapter.elements.find_by(tag: "p")
      expect(para_element.content).to eq("<p>Simple para inside of a sect4</p>")
    end
  end

  context "div.admonitionblock" do
    let(:content) do
      <<-HTML.strip
      <div class="admonitionblock note">
        <table>
          <tr>
            <td class="icon">
              <div class="title">Note</div>
            </td>
            <td class="content">
              <div class="title">This is a note</div>
              <div class="paragraph">
                <p>Notes stand out different from the text.</p>
              </div>
            </td>
          </tr>
        </table>
      </div>
      HTML
    end

    it "adds the admonitionblock element to the chapter" do
      subject.process
      element = chapter.elements.find_by(tag: "div")
      expect(element.content).to eq(content)
    end
  end

  context "div.ulist" do
    let(:content) do
      <<-HTML.strip
      <div class="ulist">
        <ul>
          <li><p>Item 1</p></li>
          <li><p>Item 2</p></li>
          <li><p>Item 3</p></li>
        </ul>
      </div>
      HTML
    end

    it "adds the admonitionblock element to the chapter" do
      subject.process
      element = chapter.elements.find_by(tag: "ul")
      expect(element.content).to eq(<<-HTML.strip
        <ul>
          <li><p>Item 1</p></li>
          <li><p>Item 2</p></li>
          <li><p>Item 3</p></li>
        </ul>
      HTML
      )
    end
  end

  context "div.quoteblock" do
    let(:content) do
      <<-HTML.strip
      <div class="quoteblock">
        <blockquote>
          <div class="paragraph">
            <p>May the force be with you.</p>
          </div>
        </blockquote>
        <div class="attribution">
          — Gandalf
        </div>
      </div>
      HTML
    end

    it "adds the quoteblock element to the chapter" do
      subject.process
      element = chapter.elements.find_by(tag: "div")
      expect(element.content).to eq(content)
    end
  end
end
