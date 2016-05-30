class Accounts::PlansController < Accounts::BaseController
  def choose
    @plans = Plan.all
    @client_token = Braintree::ClientToken.generate(
      customer_id: current_account.braintree_customer_id
    )
    render :choose
  end

  def chosen
    plan = Plan.find(params[:account][:plan_id])
    result = Braintree::Subscription.create(
      payment_method_nonce: params[:payment_method_nonce],
      plan_id: plan.braintree_id
    )

    if result.success?
      current_account.braintree_subscription_id = result.subscription.id
      current_account.plan = plan
      current_account.save
      flash[:notice] = "Your account has been successfully created."
      redirect_to root_url(subdomain: current_account.subdomain)
    else
      flash[:alert] = "Subscription failed: #{result.message}"
      choose
    end
  end
end
