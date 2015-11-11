require "rails_helper"
require "braintree_plan_fetcher"

describe BraintreePlanFetcher do
  let(:faux_plan) do
    double("Plan", 
             id: "starter",
             name: "Starter",
             price: "9.95")
  end

  it "fetches and stores plans" do
    expect(Braintree::Plan).to receive(:all).and_return([faux_plan])
    expect(Plan).to receive(:create).with({
      braintree_id: "starter",
      name: "Starter",
      price: "9.95"
    })

    BraintreePlanFetcher.store_locally
  end

  it "checks and updates plans" do
    expect(Braintree::Plan).to receive(:all).and_return([faux_plan])
    expect(Plan).to receive(:find_by).
                                with(braintree_id: faux_plan.id).
                                and_return(plan = double)
    expect(plan).to receive(:update).with({
      name: "Starter",
      price: "9.95"
    })

    expect(Plan).to_not receive(:create)

    BraintreePlanFetcher.store_locally
  end
end
