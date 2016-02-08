module Accounts
  class BaseController < ApplicationController
    before_filter :authenticate_user!

    def current_account
      @current_account ||= Account.find_by!(subdomain: request.subdomain)
    end
    helper_method :current_account

    def owner?
      current_account.owner == current_user
    end
    helper_method :owner?
  end
end
