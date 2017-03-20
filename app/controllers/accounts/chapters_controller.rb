module Accounts
  class ChaptersController < Accounts::BaseController
    before_action :authenticate_user!

    def index
      redirect_to @book
    end

    def show
      @book = find_book(params[:book_id])
      @chapter = find_chapter(@book, params[:id])
      @previous_chapter = @chapter.previous_chapter
      @next_chapter = @chapter.next_chapter
      @sections = @chapter.elements.where(tag: ["h2", "h3"]).order("id ASC")
    end
  end
end
