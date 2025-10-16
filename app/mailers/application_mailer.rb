# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'mahabubziko@gmail.com'
  include ProductHelper
  include EmailHelper
  layout 'mailer'
end
