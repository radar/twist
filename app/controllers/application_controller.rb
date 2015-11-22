class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def after_sign_out_path_for(resource)
    signed_out_path
  end

  def current_account
    nil
  end
  helper_method :current_account
end
