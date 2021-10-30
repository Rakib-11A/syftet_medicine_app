class NotificationMailer < ApplicationMailer

  def send_contact_notification(contact)
    @contact = contact
    mail(to: 'info@sattarshoppingmall.com', subject: "Contact request from: #{@contact.email}", from: 'mahabubziko@gmail.com')
  end

  def send_subscription_notification(email)
    @email = email
    mail(to: email, subject: 'E-commerce Lite subscription gift', from: 'mahabubziko@gmail.com')
  end
end
