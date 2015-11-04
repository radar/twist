class BraintreePlanFetcher
  def self.store_locally
    Braintree::Plan.all.each do |plan|
      if local_plan = Plan.find_by(braintree_id: plan.id)
        local_plan.update(
          name: plan.name,
          price: plan.price
        )
      else
        Plan.create(
          name: plan.name,
          price: plan.price,
          braintree_id: plan.id
        )
      end
    end
  end
end
