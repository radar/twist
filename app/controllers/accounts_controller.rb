class AccountsController < ApplicationController
  def new
    @account = Account.new
  end

  def create
    account = Account.create(account_params)
    flash[:notice] = "Your account has been created."
    redirect_to root_url
  end

  private

  def account_params
    params.require(:account).permit(:name)
  end
end
