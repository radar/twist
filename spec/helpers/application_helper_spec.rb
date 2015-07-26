require 'rails_helper'

describe ApplicationHelper do
  before do
    @book = double(:to_param => "rails-3-in-action")
  end

  it "can parse out commit refs in text" do
    output = Nokogiri::HTML(parse("Look at @4dfed5c please."))
    output.css("a").first["href"].should == "https://github.com/twist-books/rails-3-in-action/commit/4dfed5c"
  end

  it "can parse out note refs in the text" do
    output = Nokogiri::HTML(parse("Look at #631 please."))
    output.css("a").first["href"].should == "/books/rails-3-in-action/notes/631"
  end
end
