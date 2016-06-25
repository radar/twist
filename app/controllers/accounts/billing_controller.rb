class Accounts::BillingController < Accounts::BaseController
  skip_before_action :active_subscription_required!

  def update_payment_details
    @customer = Stripe::Customer.retrieve(current_account.stripe_customer_id)
    @customer.source = params[:token]
    @customer.save
    flash[:notice] = "Your payment details have been updated."
    redirect_to billing_path
  end
end
