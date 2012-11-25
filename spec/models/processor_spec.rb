require 'spec_helper'

describe Processor do
  it "removes whitespace from informalexamples" do
    string = <<-EOF
      <div class="informalexample">
        <pre>
          Line breaks
          
        </pre>
      </div>
    EOF
    element = Element.process_informalexample!(Chapter.new, Nokogiri::HTML(string))
    element.content.should == "<pre>Line breaks</pre>"
  end
end
