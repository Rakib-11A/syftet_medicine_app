# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  role                   :string(255)
#  name                   :string(255)
#  mobile                 :string(255)
#  landphone              :string(255)
#  ship_address_id        :integer
#  tokens                 :text(65535)
#  initial_balance        :float
#  initial_balance_date   :date
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

class User < ApplicationRecord
  include UserReporting

  ROLES = %w(admin moderator customer supplier).freeze
  ADMIN_ROLES = %w(admin moderator).freeze

  CREDIT_TYPE = {
      invoice: 'Admin::Suppliers::Invoice'
  }

  DEBIT_TYPE = {
      payment: 'Admin::Suppliers::Payment',
      discount: 'Admin::Suppliers::Discount',
      refund: 'Admin::Suppliers::Refund'
  }

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :comments
  has_many :wishlists
  has_many :reviews
  has_many :orders
  has_many :rewards_points
  belongs_to :ship_address, class_name: 'Address'
  has_many :print_barcodes
  has_many :products, foreign_key: 'supplier_id'
  has_many :invoices, dependent: :destroy, class_name: 'Admin::Suppliers::Invoice', foreign_key: 'supplier_id'
  has_many :payments, dependent: :destroy, class_name: 'Admin::Suppliers::Payment', foreign_key: 'supplier_id'
  has_many :refunds, dependent: :destroy, class_name: 'Admin::Suppliers::Refund', foreign_key: 'supplier_id'
  has_many :discounts, dependent: :destroy, class_name: 'Admin::Suppliers::Discount', foreign_key: 'supplier_id'

  accepts_nested_attributes_for :ship_address

  scope :admins, -> { where(role: ADMIN_ROLES) }
  scope :customers, -> { where(role: 'customer') }
  scope :suppliers, -> { where(role: 'supplier') }
  scope :new_customers, -> { customers.where('created_at >= ?', 15.days.ago) }
  # after_create :send_welcome_email


  ROLES.each do |role|
    define_method("#{role}?") do
      self.role == role
    end
  end

  def total_rewards
    rewards_points.collect { |rp| rp.points > 0 ? rp.points : 0 }.sum
  end

  def total_invoice(range = '')
    @calculatable_invoice = self.invoices.where("is_order = false or (is_order = true and is_received = true)" )

    if range != ''
      @total_invoice = @calculatable_invoice.where(date: range).map(&:amount).sum
    else
      @total_invoice ||= @calculatable_invoice.map(&:amount).sum
    end
  end

  def pending_payment_count
    self.payments.where(status: 'pending').count
  end

  def pending_payment(range='')
    if range != ''
      @pending_payment = self.payments.where(payment_date: range).map { |p| p.status == 'pending' ? p.amount : 0 }.sum
    else
      @pending_payment ||= self.payments.map { |p| p.status == 'pending' ? p.amount : 0 }.sum
    end
  end

  def send_welcome_email
    UserMailer.welcome(self).deliver_now
  end

  def active_invoice
    self.invoices.where(is_complete: false)
  end

  def total_transport_cost(range = '')
    if range != ''
      @total_transport_cost = self.invoices.where(date: range).sum(:transport_cost)
    else
      @total_transport_cost ||= self.invoices.sum(:transport_cost)
    end

  end

  def total_payment(range = '')
    if range != ''
      @total_payment = self.payments.where(payment_date: range).map { |p| p.complete? ? p.amount : 0 }.sum
    else
      @total_payment||= self.payments.map { |p| p.complete? ? p.amount : 0 }.sum
    end

  end

  def total_refund(range = '')
    if range != ''
      @total_refund  = self.refunds.where(date: range).map(&:amount).sum
    else
      @total_refund ||= self.refunds.map(&:amount).sum
    end

  end

  def total_discount(range = '')
    if range != ''
      @total_discount = self.discounts.where(date: range).map(&:amount).sum
    else
      @total_discount ||= self.discounts.map(&:amount).sum
    end

  end

  def due_balance(range='')
    @due_balance = self.total_invoice(range) + self.total_transport_cost(range) - self.total_payment(range) - self.total_refund(range) - self.total_discount(range) + (self.initial_balance || 0)
  end

  def last_payment_amount(range = '')
    if range != ''
      @last_payment_amount = self.payments.where(payment_date: range).map { |p| p.status == 'complete' ? p.amount : 0 }.last || 0
    else
      @last_payment_amount ||= self.payments.map { |p| p.status == 'complete' ? p.amount : 0 }.last || 0
    end
  end

  def last_payment_date
    self.payments.map { |p| p.status == 'complete' ? p.payment_date.strftime('%d/%m/%Y') : '' }.last
  end


  def total_quantity
    print_barcodes.sum(:quantity)
  end
  def available_rewards
    rewards_points.sum(:points)
  end

  def purchased
    orders.where("approved_at IS NOT NULL").sum(:total)
  end

  def last_incomplete_spree_order
    orders.incomplete.
        includes(:ship_address, line_items: [product: [:images] ]).
        order('created_at DESC').
        first
  end

  def authentication_token
    token = SecureRandom.hex(32)
    self.tokens = token
    self.save
    token
  end

end
