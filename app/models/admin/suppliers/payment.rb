# frozen_string_literal: true

module Admin
  module Suppliers
    class Payment < ApplicationRecord
      PAYMENT_METHODS = {
        cash: { value: 'cash', color: '#dc4a4a' }
        # cheque: { value: 'cheque', color: '#6a92b5' },
        # card: { value: 'card', color: '#dcc34a' },
        # bkash: { value: 'bkash', color: '#7d6359' },
        # rocket: { value: 'rocket', color: '#werwer' }
      }.freeze

      belongs_to :supplier, class_name: 'User'
      belongs_to :paid_by, foreign_key: :paid_by_id, class_name: 'User'
      belongs_to :invoice, class_name: 'Admin::Suppliers::Invoice', foreign_key: :invoice_id
      validates :amount, :payment_date, presence: true

      scope :cash, -> { where(method: 'cash') }
      scope :cheque, -> { where(method: 'cheque') }
      scope :pending, -> { where(status: 'pending') }
      scope :bounced, -> { where(status: 'bounced') }
      scope :complete, -> { where(status: 'complete') }

      before_create :set_status
      before_save :set_value_date

      def complete?
        status == 'complete'
      end

      def bounce
        if is_group_payment?
          group_check_payments = Admin::Suppliers::Payment.where(cheque_number: cheque_number, is_group_payment: true)
          group_check_payments.each do |payment|
            payment.status = 'bounced'
            payment.save
          end
        else
          self.status = 'bounced'
          save
        end
      end

      def bounced?
        status == 'bounced'
      end

      def confirm
        self.confirmed = true
        save
      end

      def confirmed?
        confirmed
      end

      def cash?
        method == 'cash'
      end

      def cheque?
        method == 'cheque'
      end

      def supplier_payment_complete
        self.status = 'complete'
        save
      end

      private

      def set_status
        self.status = 'pending'
      end

      def set_value_date
        self.value_date = payment_date if cash?
      end
    end
  end
end
