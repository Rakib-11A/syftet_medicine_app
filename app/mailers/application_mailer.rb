class ApplicationMailer < ActionMailer::Base
  default from: 'noreplysattarshoppingmall@gmail.com'
  add_template_helper(ProductHelper)
  layout 'mailer'
end
