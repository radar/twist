module Accounts
  class InvitationsController < Accounts::BaseController
    skip_before_filter :authenticate_user!, only: [:accept, :accepted]
    skip_before_filter :authorize_user!, only: [:accept, :accepted]
    before_filter :authorize_owner!, except: [:accept, :accepted]

    def new
      @invitation = Invitation.new
    end

    def create
      @invitation = current_account.invitations.new(invitation_params)
      @invitation.save
      InvitationMailer.invite(@invitation).deliver_now
      flash[:notice] = "#{@invitation.email} has been invited."
      redirect_to root_path
    end

    def accept
      @invitation = Invitation.find_by!(token: params[:id])
    end

    def accepted
      @invitation = Invitation.find_by!(token: params[:id])
      user_params = params[:user].permit(
        :email,
        :password,
        :password_confirmation
      )

      user = User.create!(user_params)
      current_account.users << user
      sign_in(user)

      flash[:notice] = "You have joined the #{current_account.name} account."
      redirect_to root_url(subdomain: current_account.subdomain)
    end

    private

    def authorize_owner!
      unless owner?
        flash[:alert] = "Only an owner of an account can do that."
        redirect_to root_url(subdomain: current_account.subdomain)
      end
    end

    def invitation_params
      params.require(:invitation).permit(:email)
    end
  end
end
