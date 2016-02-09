require "rails_helper"

feature "Accepting invitations" do
  let(:account) { FactoryGirl.create(:account) }
  let(:invitation) do
    Invitation.create(
      account: account, 
      email: "test@example.com"
    )
  end

  before do
    InvitationMailer.invite(invitation).deliver_now
    set_default_host
  end

  scenario "accepts an invitation" do
    email = open_email("test@example.com")
    accept_link = links_in_email(current_email).first
    expect(accept_link).to be_present
    visit accept_link
    fill_in "Password", with: "password"
    fill_in "Password confirmation", with: "password"
    click_button "Accept Invitation"
    expect(page).to have_content("You have joined the #{account.name} account.")
    expect(page.current_url).to eq(root_url(subdomain: account.subdomain))
  end
end
