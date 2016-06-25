class Admin::AccountsController < Admin::BaseController
  def unpaid
    @accounts = Account.where(stripe_subscription_status: "unpaid")
  end

  def search
    account = Account.find_by(subdomain: params[:subdomain])
    redirect_to [:admin, account]
  end

  def show
    @account = Account.find(params[:id])
  end
end
