require 'spec_helper'
require 'markdown_renderer'

describe MarkdownRenderer do
  let(:renderer) { Redcarpet::Markdown.new(MarkdownRenderer, :fenced_code_blocks => true) }

  def render(element)
    Nokogiri::HTML(renderer.render(element))
  end

  it "can parse a paragraph" do
    paragraph = %Q{
Once upon a time...
The end.
    }
    output = render(paragraph)
    output.css("p").text.should == paragraph.strip
  end

  it "can parse a tip" do
    tip = %Q{
T> **The constraint request object**
T> 
T> The `request` object passed in to the `matches?` call in any constraint is
T> an `ActionDispatch::Request` object, the same kind of object that is available
T> within your application's (and engine's) controllers.
T>
T> You can get other information out of this object as well, if you wish. For
T> instance, you could access the Warden proxy object with an easy call to
T> `request.env['warden']`, which you could then use to only allow routes for an
T> authenticated user.
}

    output = render(tip)
    parsed_tip = output.css("div.tip")
    parsed_tip.css("strong").text.should == "The constraint request object"
    parsed_tip.css("p").count.should == 2
  end

  it "can parse a warning" do
    warning = %Q{
W> **Don't do that!**
W>
W> Please keep all extremities clear of the whirring blades.
}

    output = render(warning)
    parsed_warning = output.css("div.warning")
    parsed_warning.css("strong").text.should == "Don't do that!"
    parsed_warning.css("p").count.should == 2
  end

  it "can parse an error" do
    error = %Q{
E> **Something went wrong**
E>
E> Not going to tell you what.
}

    output = render(error)
    parsed_error = output.css("div.error")
    parsed_error.css("strong").text.should == "Something went wrong"
    parsed_error.css("p").count.should == 2
  end

  it "can parse an information box" do
    information = %Q{
I> **Something you should know**
I>
I> This is an information box. Don't tell anyone.
}

    output = render(information)
    parsed_information = output.css("div.information")
    parsed_information.css("strong").text.should == "Something you should know"
    parsed_information.css("p").count.should == 2
  end

  it "can parse a question box" do
    question = %Q{
Q> **Is there a question?**
Q>
Q> No?
}

    output = render(question)
    parsed_question = output.css("div.question")
    parsed_question.css("strong").text.should == "Is there a question?"
    parsed_question.css("p").count.should == 2
  end

  it "can parse a discussion box" do
    discussion = %Q{
D> **Discussion area**
D>
D> Please, talk.
}

    output = render(discussion)
    parsed_discussion = output.css("div.discussion")
    parsed_discussion.css("strong").text.should == "Discussion area"
    parsed_discussion.css("p").count.should == 2
  end

  it "can parse a exercise box" do
    exercise = %Q{
X> **Exercise!**
X>
X> One, and two, and three, and four!
}

    output = render(exercise)
    parsed_exercise = output.css("div.exercise")
    parsed_exercise.css("strong").text.should == "Exercise!"
    parsed_exercise.css("p").count.should == 2
  end

  it "can parse an aside" do
    aside = %Q{
A> **Pssst, over here!**
A>
A> Did you know that this is an aside? Please keep it on the DL.
    }

    output = render(aside)
    parsed_aside = output.css("div.aside")
    parsed_aside.css("strong").text.should == "Pssst, over here!"
    parsed_aside.css("p").count.should == 2
  end

  it "can parse a titleized code listing" do
    code = %Q{
{title=lib/subscribem/constraints/subdomain_required.rb,lang=ruby,line-numbers=on}
    module Subscribem
      module Constraints
        class SubdomainRequired
          def self.matches?(request)
            request.subdomain.present? && request.subdomain != "www"
          end
        end
      end
    end

Followed by some text
}
# Two linebreaks with text is ultra important.
# Regex used to locate and pre-process code listings uses two linebreaks and
# text as a delimiter.

    output = render(code)
    parsed_code = output.css("div.code")
    parsed_code.css("div.highlight").should_not be_empty
    parsed_code.css(".highlight .k").first.text.should == "module"
  end

  it "can parse a titleized code listing with a paragraph following" do
    code = %Q{
{title=lib/subscribem/constraints/subdomain_required.rb,lang=ruby,line-numbers=on}
    module Subscribem
      module Constraints
        class SubdomainRequired
          def self.matches?(request)
            request.subdomain.present? && request.subdomain != "www"
          end
        end
      end
    end

This is just some text. Nothing to be too concerned about.
}
    output = render(code)
    parsed_code = output.css("div.code")
    parsed_code.css("div.highlight").should_not be_empty
    parsed_code.css(".highlight .k").first.text.should == "module"

    parsed_code.css("div.highlight").text.strip.should == %Q{
module Subscribem
  module Constraints
    class SubdomainRequired
      def self.matches?(request)
        request.subdomain.present? && request.subdomain != "www"
      end
    end
  end
end
    }.strip

    output.css("p").last.text.should == "This is just some text. Nothing to be too concerned about."
  end

  it "can process a footnote" do
    footnote = %Q{
[^1]: Behold, a footnote.
    }
    output = render(footnote)
    footnote = output.css(".footnote")
    footnote.text.strip.should == "Behold, a footnote."
    footnote.css("a[name=footnote_1]").should_not be_empty
  end

  it "can process a multi-char" do
    footnote = %Q{
[^123]: Behold, a footnote.
    }
    output = render(footnote)
    footnote = output.css(".footnote")
    footnote.text.strip.should == "Behold, a footnote."
    footnote.css("a[name=footnote_123]").should_not be_empty
  end

  it "can process a footnote within a paragraph" do
    footnote_within_paragraph = %Q{Hey, check out this footnote[^1]}
    output = render(footnote_within_paragraph)
    output.css("a sup").text.should == "1"
  end

  it "can process a multi-char footnote within a paragraph" do
    footnote_within_paragraph = %Q{Hey, check out this footnote[^123]}
    output = render(footnote_within_paragraph)
    output.css("a sup").text.should == "1"
  end
end
