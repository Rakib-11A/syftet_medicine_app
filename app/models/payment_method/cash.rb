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

class PaymentMethod::Cash < ::PaymentMethod
    PREFERENCES = [].freeze
    include Preferable

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

    def capture(payment)
      payment.state = 'captured'
      return unless payment.save

      payment.order.update_attribute(:payment_state, 'paid')
    end

    def cancel(*)
      simulated_successful_billing_response
    end

    def void(payment)
      payment.state = 'void'
      return unless payment.save

      payment.order.update_attribute(:payment_state, 'void')
    end

    def source_required?
      false
    end

    def payment_process
      { state: 'captured', response_code: 200, response_message: 'Payment success' }
    end

    def process
      { state: 'pending', response_code: 200, response_message: 'Payment success' }
    end

    def credit(*)
      simulated_successful_billing_response
    end
end
