# frozen_string_literal: true

# == Schema Information
#
# Table name: payment_methods
#
#  id          :integer          not null, primary key
#  type        :string
#  name        :string
#  description :text
#  active      :boolean
#  preferences :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class PaymentMethod::CreditPoint < ::PaymentMethod
    def actions
      %w[capture void]
    end

    # Indicates whether its possible to capture the payment
    def can_capture?(payment)
      %w[checkout pending].include?(payment.state)
    end

    # Indicates whether its possible to void the payment.
    def can_void?(payment)
      payment.state != 'void'
    end

    def process
      { state: 'pending', response_code: 200, response_message: 'Payment success' }
    end

    def capture(payment)
      payment.state = 'captured'
      return unless payment.save

      payment.order.update_attribute(:payment_state, 'paid')
    end

    def purchase(_amount, _source, _options = {})
      simulated_successful_billing_response
    end

    def cancel(amount, _source, order, _code)
      response = simulated_successful_billing_response
      update_rewards_points(amount.to_f, 'Purchased Canceled', order) if response.success?
      response
    end

    def void(*)
      simulated_successful_billing_response
    end

    def source_required?
      false
    end

    def credit(*)
      simulated_successful_billing_response
    end

    private

    def simulated_successful_billing_response
      ActiveMerchant::Billing::Response.new(true, '', {}, { authorization: true })
    end

    def update_rewards_points(amount, reason, order)
      p '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'
      return unless order.present?

      order_id = order.id
      user_id = order.user_id
      RewardsPoint.create(order_id: order_id, points: amount, reason: reason, user_id: user_id)
    end
end
