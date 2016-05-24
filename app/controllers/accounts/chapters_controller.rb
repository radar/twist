module Accounts
  class ChaptersController < Accounts::BaseController
    before_action :find_book

    def index
      redirect_to @book
    end
    
    def show
      @chapter = @book.chapters.find_by(permalink: params[:id])
      @previous_chapter = @chapter.previous_chapter
      @next_chapter = @chapter.next_chapter
    end
    
    private
    
    def find_book
      @book = Book.find_by_permalink(params[:book_id])
    end
  end
end
