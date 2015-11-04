class AccountsController < ApplicationController
  def new
    unless signup_enabled?
      flash[:alert] = "Not taking signups at this time."
      redirect_to root_url
    end

    @account = Account.new
    @account.build_owner
  end

  def create
    @account = Account.new(account_params)
    if @account.save
      result = Braintree::Customer.create(
        email: @account.owner.email
      )
      @account.update_column(:braintree_customer_id, result.customer.id)
      sign_in(@account.owner)
      flash[:notice] = "Your account has been successfully created."
      redirect_to root_url(subdomain: @account.subdomain)
    else
      flash.now[:alert] = "Sorry, your account could not be created."
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
