module Accounts
  class BaseController < ApplicationController
    before_action :authenticate_user!
    before_action :authorize_user!
    before_action :subscription_required!

    private

    def authorize_user!
      authenticate_user!
      unless current_account.owner == current_user ||
             current_account.users.exists?(current_user.id)
        flash[:notice] = "You are not permitted to view that account."
        redirect_to root_url(subdomain: nil)
      end
    end

    def current_account
      @current_account ||= Account.find_by(subdomain: request.subdomain)
    end
    helper_method :current_account

    def owner?
      current_account.owner == current_user
    end
    helper_method :owner?

    def subscription_required!
      if owner?
        check_subscription_for_owner!
      else
        check_subscription_for_user!
      end
    end

    def check_subscription_for_owner!
      if current_account.braintree_subscription_id.present?
        return unless current_account.braintree_subscription_status == 'Canceled'
        message = "Welcome back! Please choose a plan to re-subscribe to Twist."
        flash[:alert] = message
        redirect_to choose_plan_url
      else
        message = "You must subscribe to a plan before you can use your account."
        flash[:alert] = message
        redirect_to choose_plan_url
      end
    end

    def check_subscription_for_user!
      return unless current_account.braintree_subscription_id.nil? ||
        current_account.braintree_subscription_status == 'Canceled'

      message = "There are subscription issues with the #{current_account.subdomain} account."
      message += " Please notify the account owner."
      flash[:alert] = message
      redirect_to root_url(subdomain: nil)
    end

    def owner_required!
      return if owner?

      redirect_to root_url(subdomain: current_account.subdomain)
      flash[:alert] = "You are not allowed to do that."
    end
  end
end
