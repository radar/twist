class UsersController < ApplicationController
  def signed_out
    flash[:notice] = "You have been successfully signed out."
    redirect_to new_user_session_path
  end
end