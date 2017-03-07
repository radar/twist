module Accounts
  class ElementsController < Accounts::BaseController
    before_action :authenticate_user!
    before_action :find_book_and_chapter

    def index
      @elements = @chapter.elements
      fresh_when(@chapter)
    end

    def find_book_and_chapter
      @book = current_account.books.find_by!(permalink: params[:book_id])
      @chapter = @book.chapters.find_by!(permalink: params[:chapter_id])
    end
  end
end
