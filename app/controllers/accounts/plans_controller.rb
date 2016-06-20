class Accounts::PlansController < Accounts::BaseController
  skip_before_action :subscription_required!

  def choose
    @plans = Plan.order(:amount)
  end

  def chosen
    customer = Stripe::Customer.retrieve(current_account.stripe_customer_id)
    plan = Plan.find(params[:account][:plan_id])
    subscription = customer.subscriptions.create(
      plan: plan.stripe_id,
      source: params[:token]
    )

    current_account.plan = plan
    current_account.stripe_subscription_id = subscription.id
    current_account.save
    flash[:notice] = "Your account has been created."
    redirect_to root_url(subdomain: current_account.subdomain)
  end

  def cancel
    customer = Stripe::Customer.retrieve(current_account.stripe_customer_id)
    subscription = customer.subscriptions.retrieve(current_account.stripe_subscription_id).delete
    if subscription.status == "canceled"
      current_account.update_column(:stripe_subscription_id, nil)
      flash[:notice] = "Your subscription to Twist has been cancelled."
      redirect_to root_url(subdomain: nil)
    end
  end
end
