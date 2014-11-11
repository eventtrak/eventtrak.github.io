class TicketMailer < ActionMailer::Base
  default from: "\"Tunetap Tickets\" <thetap@tunetap.com>"

  def user_ticket(ticket)
    @ticket_code = ticket.code
    mail(to: ticket.user.email, subject: 'Your ticket: Dylan Owen and Tone Perignon at The Gates (12/5)')
  end
end
