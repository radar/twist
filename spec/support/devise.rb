module DeviseExtensions
  def actually_sign_in_as(user)
    visit root_path
    click_link "Sign in"
    fill_in "Email", :with => user.email
    fill_in "Password", :with => "password" # test password
    click_button "Sign in"
  end
  
  def create_user!(attributes={})
    user = Factory.create(:user, attributes)
    user.confirm!
    user
  end
end

RSpec.configure do |config|
  config.include DeviseExtensions
end
