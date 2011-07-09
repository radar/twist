class BooksController < ApplicationController
  def new
    @book = Book.new
  end
  
  def create
    @book = Book.new(params[:book])
    if @book.save
      flash[:notice] = "Thanks! Your book is now being processed. Please wait."
      redirect_to book_path(@book)
    # else
    #   flash[:alert] = "Book could not be created."
    #   render :action => "new"
    end
  end
  
  def show
    @book = Book.find(params[:id])
  end

  def receive
    @book = Book.find(params[:id])
    @book.enqueue
    render :nothing => true
  end
end
