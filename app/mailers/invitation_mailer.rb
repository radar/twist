class InvitationMailer < ApplicationMailer
  def invite(invitation)
    @invitation = invitation
    mail(
      to: invitation.email,
      subject: "Invitation to join #{invitation.account.name} on Twist"
    )
  end
end
