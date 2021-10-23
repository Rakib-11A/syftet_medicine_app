class Admin::Suppliers::Refund < ApplicationRecord


  validates :supplier_id, :amount, :date, presence: true

  belongs_to :supplier, class_name: 'User'
  belongs_to :employee, class_name: 'User'
  belongs_to :invoice, class_name: 'Admin::Suppliers::Invoice', foreign_key: :invoice_id
  has_many :items, class_name: 'Admin::Suppliers::RefundItem', dependent: :destroy

  accepts_nested_attributes_for :items,
                                allow_destroy: true,
                                :reject_if => proc { |attributes|
                                  attributes['product_id'].blank?
                                }

  scope :from_order, -> { where(is_order: true) }


  def calculate_refund_amount
    refund_amount = items.sum(:amount)
    update_attributes(amount: refund_amount)
  end

  def item_count
    items.sum(:quantity)
  end
end
