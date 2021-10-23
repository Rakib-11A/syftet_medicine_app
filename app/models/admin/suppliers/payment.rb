class Admin::Suppliers::Payment < ApplicationRecord
  PAYMENT_METHODS = {
      cash: { value: 'cash', color: '#dc4a4a' },
      #cheque: { value: 'cheque', color: '#6a92b5' },
      # card: { value: 'card', color: '#dcc34a' },
      # bkash: { value: 'bkash', color: '#7d6359' },
      # rocket: { value: 'rocket', color: '#werwer' }
  }

  belongs_to :supplier, class_name: 'User'
  belongs_to :paid_by, foreign_key: :paid_by_id, class_name: "User"
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
    self.status == "complete"
  end

  def bounce
    if self.is_group_payment?
      group_check_payments = Admin::Suppliers::Payment.where(cheque_number: self.cheque_number, is_group_payment: true)
      group_check_payments.each do |payment|
        payment.status = "bounced"
        payment.save
      end
    else
      self.status = "bounced"
      self.save
    end
  end

  def bounced?
    self.status == "bounced"
  end

  def confirm
    self.confirmed = true
    self.save
  end

  def confirmed?
    self.confirmed
  end

  def cash?
    self.method == 'cash'
  end

  def cheque?
    self.method == 'cheque'
  end

  def supplier_payment_complete
    self.status = "complete"
    self.save
  end

  private
  def set_status
    self.status = "pending"
  end

  def set_value_date
    self.value_date = self.payment_date if self.cash?
  end


end
