require 'spec_helper'

describe 'chapters' do                           
  let(:user) { create_user! }
  before do
    Resque.remove_queue("normal") # TODO: is there a better way than just putting this *everywhere*?
    @book = Book.create(:title => "Rails 3 in Action", 
                        :path => "http://github.com/radar/rails3book_test")
    run_resque_job!
    actually_sign_in_as(user)
  end
  
  it "can view a given chapter" do
    visit book_chapter_path(@book, @book.chapters.first)
    page!
  end
end