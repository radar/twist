module Accounts
  class BooksController < Accounts::BaseController
    skip_before_action :active_subscription_required!, only: [:index]
    skip_before_action :authenticate_user!, only: [:receive]
    skip_before_action :verify_authenticity_token, only: :receive
    skip_before_action :authorize_user!, only: [:receive]
    before_action :check_plan_limit, only: [:new, :create]

    def index
      @books = current_account.books
    end

    def new
      @book = Book.new
    end
    
    def create
      @book = current_account.books.build(book_params)
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
      @book = current_account.books.find_by!(permalink: params[:id])
      @frontmatter = @book.chapters.frontmatter
      @mainmatter = @book.chapters.mainmatter
      @backmatter = @book.chapters.backmatter
      rescue ActiveRecord::RecordNotFound
        flash[:alert] = "Book not found."
        redirect_to root_url
    end

    def receive
      @book = Book.find_by_permalink(params[:id])
      @book.enqueue
      head :ok
    end

    private

    def book_params
      params.require(:book).permit(:title, :path, :blurb)
    end

    def check_plan_limit
      if current_account.plan.books_allowed == current_account.books.count
        session[:return_to] = request.fullpath
        message = "You have reached your plan's limit."
        message += " You need to upgrade your plan to add more books."
        flash[:alert] = message
        redirect_to account_choose_plan_path
      end
    end
  end
end
