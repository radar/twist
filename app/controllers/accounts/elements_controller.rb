module Accounts
  class ElementsController < Accounts::BaseController
    before_action :authenticate_user!
    before_action :find_book_and_chapter

    def index
      @elements = @chapter.elements
      fresh_when(@chapter)
    end

    def find_book_and_chapter
      @book = find_book(params[:book_id])
      @chapter = find_chapter(@book, params[:chapter_id])
    end
  end
end
