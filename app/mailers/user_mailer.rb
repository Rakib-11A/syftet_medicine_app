class UserMailer < ApplicationMailer
  default "Message-ID" => "#{Digest::SHA2.hexdigest(Time.now.to_i.to_s)}@sattarshoppingmall.com"

  def welcome(user)
    @user = user
    mail(to: user.email, from: 'mahabubziko@gmail.com', subject: 'Welcome To sattarshoppingmall.com')
  end

  def reset_password_instructions(user, token, *args)
    @edit_password_reset_url = edit_user_password_url(:reset_password_token => token)
    @user = user
    mail to: user.email, from: 'mahabubziko@gmail.com', subject: 'Sattarshoppingmall.com ' + I18n.t(:subject, :scope => [:devise, :mailer, :reset_password_instructions])
  end

  # def product_subscription(subscriber)
  #   @subscribers = subscriber
  #   mail to: subscriber.email, from: 'noreplysattarshoppingmall@gmail.com', subject: 'This product added'
  # end

end
