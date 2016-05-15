class Accounts::BillingController < Accounts::BaseController
  skip_before_action :active_subscription_required!

  def payment_details
    @customer = find_customer
  end

  def update_payment_details
    @customer = find_customer
    @customer.source = params[:token]
    @customer.save
    current_account.update_card_details(@customer.sources.first)
    flash[:notice] = "Your payment details have been updated."
    redirect_to billing_path
  end

  def find_customer
    Stripe::Customer.retrieve(current_account.stripe_customer_id)
  end

end
