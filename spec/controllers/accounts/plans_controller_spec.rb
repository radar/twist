require 'rails_helper'

RSpec.describe Accounts::PlansController, type: :controller do
  context "as an account owner" do
    let!(:account) { FactoryGirl.create(:account, :subscribed) }

    let!(:starter_plan) do
      Plan.create(
        name: "Starter",
        stripe_id: "starter",
        books_allowed: 1
      )
    end

    let!(:silver_plan) do
      Plan.create(
        name: "Silver",
        stripe_id: "silver",
        books_allowed: 3
      )
    end

    before do
      allow(controller).to receive(:authenticate_user!)
      allow(controller).to receive(:current_user).and_return(account.owner)
      allow(controller).to receive(:current_account).and_return(account)

      account.plan = silver_plan
      account.books << FactoryGirl.create_list(:book, 3)
      account.save
    end

    context "with 3 books" do
      it "cannot switch to the starter plan" do
        expect(Stripe::Customer).not_to receive(:retrieve)

        put :switch, plan_id: starter_plan.id
        expect(flash[:alert]).to eq(
          "You cannot switch to that plan." +
          " Your account is over that plan's limit.")
        expect(response).to redirect_to(choose_plan_path)

        account.reload
        expect(account.plan).to eq(silver_plan)
      end
    end
  end
end
