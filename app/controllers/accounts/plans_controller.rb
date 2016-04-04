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
    flash[:notice] = "Your account has been successfully created."
    redirect_to root_url(subdomain: current_account.subdomain)
  end

  def cancel
    customer = Stripe::Customer.retrieve(current_account.stripe_customer_id)
    subscription = customer.subscriptions.retrieve(current_account.stripe_subscription_id).delete

    if subscription.status == "canceled"
      current_account.stripe_subscription_id = nil
      current_account.save
      flash[:notice] = "Your subscription to Twist has been cancelled."
      redirect_to root_url(subdomain: nil)
    end
  end

  def switch
    plan = Plan.find(params[:plan_id])
    customer = Stripe::Customer.retrieve(current_account.stripe_customer_id)
    subscription = customer.subscriptions.retrieve(current_account.stripe_subscription_id)
    subscription.plan = plan.stripe_id
    subscription.save

    current_account.update_column(:plan_id, plan.id)

    flash[:notice] = "You have changed to the #{plan.name} plan."
    redirect_to root_url
  end
end
