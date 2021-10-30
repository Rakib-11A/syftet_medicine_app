class ApplicationMailer < ActionMailer::Base
  default from: 'mahabubziko@gmail.com'
  add_template_helper(ProductHelper)
  add_template_helper(EmailHelper)
  layout 'mailer'
end
