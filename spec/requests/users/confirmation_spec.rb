require 'spec_helper'

describe "confirmation" do
  before do
    Factory.create(:user, :email => "user@example.com")
  end
  
  it "can confirm their account" do
    confirmation_email = find_email("user@example.com")
    click_first_link_in_email(confirmation_email)
    page.should have_content("Your account was successfully confirmed. You are now signed in.")
  end
end
