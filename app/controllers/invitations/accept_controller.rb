module Accounts
  module Invitations
    class AcceptController < Accounts::BaseController
      # Acceptance#new
      # GET /invitations/1/accept
      def new
        store_location_for(:user, request.fullpath)
        @invitation = Invitation.find_by!(token: params[:invitation_id])
      end

      # Acceptance#create
      # POST /invitations/1/accept
      def create
        @invitation = Invitation.find_by!(token: params[:invitation_id])

        if user_signed_in?
          user = current_user
        else
          user_params = params[:user].permit(
            :email,
            :password,
            :password_confirmation
          )

          user = User.create!(user_params)
          sign_in(user)
        end

        current_account.users << user

        flash[:notice] = "You have joined the #{current_account.name} account."
        redirect_to root_url(subdomain: current_account.subdomain)
      end
    end
  end
end
