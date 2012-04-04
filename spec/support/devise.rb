module DeviseExtensions
  def actually_sign_in_as(user)
    visit root_path
    click_link "Sign in"
    fill_in "Email", :with => user.email
    fill_in "Password", :with => "password" # test password
    click_button "Sign in"
  end
  
  def create_user!(attributes={})
    user = FactoryGirl.create(:user, attributes)
    user
  end

  def create_author!(attributes={})
    create_user!(attributes.merge!(:author => true))
  end
end

RSpec.configure do |config|
  config.include DeviseExtensions
end
