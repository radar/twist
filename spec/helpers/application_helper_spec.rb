require 'rails_helper'

describe ApplicationHelper do
  before do
    @book = double(:to_param => "rails-3-in-action")
  end

  it "can parse out commit refs in text" do
    output = Nokogiri::HTML(parse("Look at @4dfed5c please."))
    commit_url = "https://github.com/twist-books/rails-3-in-action/commit/4dfed5c"
    expect(output.css("a").first["href"]).to eq(commit_url) 
  end

  it "can parse out note refs in the text" do
    output = Nokogiri::HTML(parse("Look at #631 please."))
    note_path = "/books/rails-3-in-action/notes/631"
    expect(output.css("a").first["href"]).to eq(note_path) 
  end
end
