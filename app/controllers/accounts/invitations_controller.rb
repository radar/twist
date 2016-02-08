module Accounts
  class InvitationsController < Accounts::BaseController
    before_filter :authorize_owner!

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
