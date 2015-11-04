class Accounts::PlansController < Accounts::BaseController
  def choose
    @plans = Plan.all
    @client_token = Braintree::ClientToken.generate(
      customer_id: current_account.braintree_customer_id
    )
  end

  def chosen
    current_account.plan_id = params[:account][:plan_id]
    current_account.save
    flash[:notice] = "Your account has been successfully created."
    redirect_to root_url(subdomain: current_account.subdomain)
  end
end
