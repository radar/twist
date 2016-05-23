class AccountsController < ApplicationController
  def new
    @account = Account.new
    @account.build_owner
  end

  def create
    account = Account.create(account_params)
    sign_in(account.owner)
    flash[:notice] = "Your account has been created."
    redirect_to root_url(subdomain: account.subdomain)
  end

  private

  def account_params
    params.require(:account).permit(:name, :subdomain,
      { owner_attributes: [
        :email, :password, :password_confirmation
      ]}
    )
  end
end
