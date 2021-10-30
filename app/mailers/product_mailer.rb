class ProductMailer < ApplicationMailer

  def product_subscription(email, product)
    @email = email
    @product = product
    mail(to: email, from: 'mahabubziko@gmail.com', subject: 'Please Check this Nice Product')
  end
end
