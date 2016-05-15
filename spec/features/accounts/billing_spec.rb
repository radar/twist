require 'rails_helper'

feature "Account Billing" do
  let(:account) do
    FactoryGirl.create(:account, :subscribed,
      stripe_subscription_status: "unpaid")
  end
end
