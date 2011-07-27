class NotesController < ApplicationController
  before_filter :authenticate_user!

  def new
    @note = Note.new
  end
end