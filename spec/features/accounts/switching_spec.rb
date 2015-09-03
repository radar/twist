require "rails_helper"

describe "Switching accounts" do
  let(:account_1) do
    FactoryGirl.create(:account, 
      name: "Account #1", 
      subdomain: "account-1"
    )
  end

  let(:account_2) do
    FactoryGirl.create(:account, 
      name: "Account #2", 
      subdomain: "account-2"
    )
  end

  before do
    account_2.users << account_1.owner
    login_as(account_1.owner)
  end

  it "can switch between accounts" do
    set_subdomain('account-1')
    visit root_url
    click_link "Twist"
    expect(page.current_url).to eq(root_url(subdomain: nil))
    click_link "Account #2"
    expect(page.current_url).to eq(root_url(subdomain: 'account-2'))
  end
end
