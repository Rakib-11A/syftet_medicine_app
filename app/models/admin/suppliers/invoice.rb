class Admin::Suppliers::Invoice < ApplicationRecord
  ORDER_STATES = {
      hold: { data: 'hold', view: 'Hold' },
      complete: { data: 'complete', view: 'Complete' },
      received: { data: 'received', view: 'Received' }
  }
  validates :supplier_id, :date, presence: true
  belongs_to :supplier, class_name: 'User'
  belongs_to :stock_location
  belongs_to :issued_by, class_name: 'User', foreign_key: 'issued_by_id'
  belongs_to :received_by, class_name: 'User', foreign_key: 'received_by_id'
  has_many :attachments, class_name: 'Admin::Suppliers::Invoices::Attachment', dependent: :destroy
  has_many :payments, class_name: 'Admin::Suppliers::Payment', foreign_key: 'invoice_id', dependent: :destroy
  has_many :refunds, class_name: 'Admin::Suppliers::Refund', foreign_key: 'invoice_id', dependent: :destroy
  has_many :discounts, class_name: 'Admin::Suppliers::Discount', foreign_key: 'invoice_id', dependent: :destroy
  has_many :items, class_name: 'Admin::Suppliers::InvoiceItem', dependent: :destroy

  after_create :generate_invoice_no

  accepts_nested_attributes_for :attachments, allow_destroy: true
  accepts_nested_attributes_for :items,
                                :allow_destroy => true,
                                :reject_if => proc { |attributes|
                                  attributes['product_id'].blank?
                                }

  accepts_nested_attributes_for :payments,
                                :allow_destroy => true,
                                :reject_if => :check_condition


  scope :purchase_orders, -> { where(is_order: true) }
  scope :invoices, -> { where(is_order: false ) }
  #scope :purchase_orders, -> { orders.where(order_state: ORDER_STATES[:complete][:data] || ORDER_STATES[:received][:data] ) }
  scope :received, -> { where(is_received: true) }

  def generate_invoice_no
    self.no = "INVO-#{Date.today.strftime("%Y")}-#{id}"
    self.save!
  end

  def invoice_amount
    self.amount = total_order
    self.save!
  end


  def paid
    payments.complete.sum(:amount)
  end

  def due_amount
    amount - (paid + discounts.sum(:amount) + total_refund)
  end

  def total_refund
    refunds.sum(:amount)
  end

  def total_receive_quantity
    received_quantity = 0
    items.each do |item|
      if item.received_quantity.present?
        received_quantity += item.received_quantity
      else
        received_quantity += item.issued_quantity
      end
    end
    received_quantity
  end

  def total_receive_amount
    total_amount = 0.0
    items.each do |item|
      if item.received_quantity.present?
        total_amount += item.cost_price * item.received_quantity
      else
        total_amount += item.total
      end
    end
    total_amount
  end

  def total_discount
    discounts.sum(:amount)
  end

  def order_refund
    refunds.from_order.first
  end

  def total_order
    items.sum(:total)
  end
  def total_item
    items.count
  end
  def receive_quantity
      items.each do |item|
        item.received_quantity = item.issued_quantity
        item.total = (item.issued_quantity * item.cost_price)
        item.save!
      end
  end
end
