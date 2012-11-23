require 'spec_helper'

describe MarkdownRenderer do
  let(:renderer) { Redcarpet::Markdown.new(MarkdownRenderer) }

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
}
    output = render(code)
    parsed_code = output.css("div.code")
    parsed_code.css("div.highlight").should_not be_empty
    parsed_code.css(".highlight .n").first.text.should == "module"
  end
end
