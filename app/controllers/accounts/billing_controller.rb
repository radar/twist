module Accounts
  class BillingController < Accounts::BaseController
    def index
      @client_token = Braintree::ClientToken.generate(
        customer_id: current_account.braintree_customer_id
      )
    end

    def update
      result = Braintree::Subscription.update(
        current_account.braintree_subscription_id,
        payment_method_nonce: params[:payment_method_nonce]
      )

      flash[:notice] = "Payment details have been updated."
      redirect_to billing_path
    end
  end
end
