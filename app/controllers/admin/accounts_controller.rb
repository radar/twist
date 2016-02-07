class Admin::AccountsController < Admin::BaseController
  def search
    account = Account.find_by(subdomain: params[:subdomain])
    redirect_to [:admin, account]
  end

  def show
    @account = Account.find(params[:id])
  end

  def past_due
    @accounts = Account.where(braintree_subscription_status: "Past Due")
  end
end
