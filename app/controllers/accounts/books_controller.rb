module Accounts
  class BooksController < Accounts::BaseController
    skip_before_action :authenticate_user!, only: [:receive]
    skip_before_action :verify_authenticity_token, only: :receive
    skip_before_action :authorize_user!, only: [:receive]

    def index
      @books = Book.where(hidden: false)
    end

    def new
      @book = Book.new
    end
    
    def create
      @book = Book.new(book_params)
      if @book.save
        @book.enqueue
        flash[:notice] = "#{@book.title} has been enqueued for processing."
        redirect_to book_path(@book)
      # else
      #   flash[:alert] = "Book could not be created."
      #   render :action => "new"
      end
    end
    
    def show
      @book = Book.find_by_permalink(params[:id])
      @frontmatter = @book.chapters.frontmatter
      @mainmatter = @book.chapters.mainmatter
      @backmatter = @book.chapters.backmatter
    end

    def receive
      @book = Book.find_by_permalink(params[:id])
      @book.enqueue
      head :ok
    end

    def book_params
      params.require(:book).permit(:title, :path, :blurb)
    end
  end
end
