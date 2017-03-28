require 'rails_helper'

describe Accounts::BooksController do
  before do
    @book = FactoryGirl.create(:book)
    @account = FactoryGirl.create(:account)
  end

  it "enqueues a book" do
    allow(controller).to receive(:current_account).and_return(@account)
    expect(Book).to receive(:find_by).and_return(@book)
    expect(@book).to receive(:enqueue)
    post :receive, params: { id: @book.permalink }
  end
end
