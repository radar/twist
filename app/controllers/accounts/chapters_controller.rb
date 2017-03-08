module Accounts
  class ChaptersController < Accounts::BaseController
    before_action :authenticate_user!
    before_action :find_book

    def index
      redirect_to @book
    end

    def show
      @chapter = find_chapter(params[:id])
      @previous_chapter = @chapter.previous_chapter
      @next_chapter = @chapter.next_chapter
      @sections = @chapter.elements.where(tag: ["h2", "h3"]).order("id ASC")
    end

    private

    def find_book
      @book = current_account.books.find_by!(permalink: params[:book_id])
    end

    def find_chapter(permalink)
      @book.chapters.find_by(permalink: permalink)
    end
  end
end
