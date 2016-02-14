module Accounts
  class BaseController < ApplicationController
    before_action :authorize_user!

    def current_account
      @current_account ||= Account.find_by!(subdomain: request.subdomain)
    end
    helper_method :current_account

    def owner?
      current_account.owner == current_user
    end
    helper_method :owner?

    private

    def authorize_user!
      authenticate_user!
      unless current_account.owner == current_user || 
             current_account.users.exists?(current_user.id)
        flash[:notice] = "You are not permitted to view that account."
        redirect_to root_url(subdomain: nil)
      end
    end

    def authorize_owner!
      unless owner?
        flash[:alert] = "Only an owner of an account can do that."
        redirect_to root_url(subdomain: current_account.subdomain)
      end
    end

  end
end
