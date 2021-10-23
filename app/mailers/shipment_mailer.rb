class ShipmentMailer < ApplicationMailer
  default from: "sattarshoppingmall.com <noreplysattarshoppingmall@gmail.com>"

  def shipped_email(shipment, resend = false)
    @shipment = shipment.respond_to?(:id) ? shipment : Shipment.find(shipment)
    subject = (resend ? "[#{I18n.t(:resend).upcase}] " : '')
    subject += " #{I18n.t('shipment_mailer.shipped_email.subject')} ##{@shipment.order.number}"
    if  @shipment.order.email.present? || @shipment.order.user.present?
      @shipment.order.email.present? ? email = @shipment.order.email : email = @shipment.order.user.email
      mail(to: email, subject: subject)#, delivery_method_options: Order::ORDER_SMTP)
    end
  end
end
#{Store.current.name}
