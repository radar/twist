require 'rails_helper'

describe 'signing out' do
  before do
    user = create_user!
    actually_sign_in_as(user)
    visit root_path
  end
  
  it "can sign out" do
    click_link "Sign out"
    page.should have_content("You have been successfully signed out.")
  end
end