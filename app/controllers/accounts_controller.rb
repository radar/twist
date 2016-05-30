class AccountsController < ApplicationController
  def new
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
      redirect_to choose_plan_url(subdomain: @account.subdomain)
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
