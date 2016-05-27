class InvitationMailer < ApplicationMailer
  def invite(invitation, account)
    @invitation = invitation
    @account = account
    mail(
      to: invitation.email,
      subject: "Invitation to join #{account.name} on Twist"
    )
  end
end
