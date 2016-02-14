class Accounts::UsersController < Accounts::BaseController
  before_action :authorize_owner!

  def destroy
    user = User.find(params[:id])
    current_account.users.delete(user)
    flash[:notice] = "#{user.email} has been removed from this account."
    redirect_to users_path
  end
end
