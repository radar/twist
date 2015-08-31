class AccountsController < ApplicationController
  def new
    @account = Account.new
    @account.build_owner
  end

  def create
    @account = Account.new(account_params)
    if @account.save
      sign_in(@account.owner)
      flash[:notice] = "Your account has been successfully created."
      redirect_to root_url(subdomain: @account.subdomain)
    else
      flash[:alert] = "Sorry, your account could not be created."
      render :new
    end
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
