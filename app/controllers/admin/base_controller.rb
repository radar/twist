class Admin::BaseController < ApplicationController
  before_action :authorize_admin!

  private

  def authorize_admin!
    return true if current_user && current_user.admin?

    flash[:alert] = "You are not permitted to access that."
    redirect_to root_url
  end
end
