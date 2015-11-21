module Accounts::PlansHelper
  def choose_plan_button_label
    if current_account.subscribed?
      "Change Plan"
    else
      "Finish"
    end
  end
end
