require 'rails_helper'

describe Accounts::BooksController do
  before do
    # Needs to exist (and have called Resque.enqueue) before we trigger the post-receive hook
    @book = FactoryGirl.create(:book)
  end
  
  it "post-receive hooks" do
    expect(Book).to receive(:find_by).and_return(@book)
    expect(@book).to receive(:enqueue)
    post :receive, :id => @book.permalink
  end
end
