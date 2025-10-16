# frozen_string_literal: true

# == Schema Information
#
# Table name: refunds
#
#  id         :integer          not null, primary key
#  payment_id :integer
#  amount     :decimal(, )
#  reason     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Refund < ApplicationRecord
  belongs_to :payment
  before_create :check_payment_amount

  private

  def check_payment_amount
    p '<<<<<<<<<<<<<<<<<<<<<<<<<<<<,'
    p inspect
    p '<<<<<<<<<<<<<<<<<<<<<<<<<<<<,'
    payment = Payment.find_by_id(payment_id)
    refund = payment.refunds.sum(:amount)
    total_refund = refund + amount
    return unless payment.amount < total_refund

    errors[:base] << 'Refund amount must be less than or equal payment amount'
    raise ActiveRecord::RecordInvalid, self
  end
end
