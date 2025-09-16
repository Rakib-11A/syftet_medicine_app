# == Schema Information
#
# Table name: orders
#
#  id                     :integer          not null, primary key
#  number                 :string(255)
#  item_total             :decimal(10, )    default(0)
#  total                  :decimal(10, )    default(0)
#  state                  :string(255)
#  adjustment_total       :decimal(10, )    default(0)
#  user_id                :integer
#  completed_at           :datetime
#  ship_address_id        :integer
#  payment_total          :decimal(10, )    default(0)
#  shipment_state         :string(255)
#  payment_state          :string(255)
#  email                  :string(255)
#  currency               :string(255)
#  created_by_id          :string(255)
#  shipment_total         :decimal(10, )    default(0)
#  promo_total            :decimal(10, )    default(0)
#  item_count             :integer
#  approver_id            :integer
#  approved_at            :datetime
#  confirmation_delivered :boolean
#  guest_token            :string(255)
#  canceled_at            :datetime
#  canceler_id            :integer
#  store_id               :integer
#  shipment_date          :date
#  shipment_progress      :integer          default(0)
#  shipped_at             :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  special_instructions   :text(65535)
#  collection_point       :string(255)
#  tax_total              :decimal(10, )    default(0)
#

# require 'order/checkout'
class Order < ApplicationRecord
  PAYMENT_STATES = %w[balance_due credit_owed failed paid void].freeze
  SHIPMENT_STATES = %w[backorder canceled partial processing pending ready shipped delivered canceled refunded].freeze
  PREFIX = 'OR-'.freeze
  ORDER_SHIPMENT_STATE = {
    processing: 'Processing',
    payment_failed: 'Payment failed',
    pending: 'Preparing your order',
    ready: 'Ready to ship',
    shipped: 'Shipped'
  }.freeze

  ORDER_STATES = %w[address delivery payment completed approved canceled].freeze

  ORDER_ALL_SHIPMENT_STATE = {
    processing: 'Processing',
    payment_failed: 'Payment failed',
    pending: 'Preparing your order',
    ready: 'Ready to ship',
    shipped: 'Shipped',
    delivered: 'Delivered',
    canceled: 'Canceled',
    refunded: 'Refunded'
  }.freeze

  # ORDER_SMTP = {
  #   address: 'smtp.gmail.com',
  #   port: 587,
  #   domain: 'gmail.com',
  #   user_name: 'syftetltd@gmail.com',
  #   password: 'nazrulziko',
  #   authentication: :login,
  #   enable_starttls_auto: true,
  #   openssl_verify_mode: 'none'
  # }.freeze

  CHECKOUT_STEPS = {
    address: 'Address',
    delivery: 'Delivery',
    payment: 'Payment',
    complete: 'complete'
  }.freeze

  extend FriendlyId
  include GenerateNumber

  friendly_id :number, slug_column: :number, use: :slugged

  belongs_to :user, optional: true
  belongs_to :canceler , class_name: 'User', optional: true
  belongs_to :admin, class_name: 'User', optional: true
  belongs_to :ship_address, foreign_key: :ship_address_id, class_name: 'Address', optional: true
  belongs_to :store, class_name: 'StockLocation'
  has_many :line_items
  has_one :shipment
  # has_many :shipments
  has_many :payments
  has_many :customer_returns
  belongs_to :admin_coupon, :class_name => 'Admin::Coupon', optional: true
  belongs_to :product, :class_name => 'Product', optional: true


  accepts_nested_attributes_for :line_items
  accepts_nested_attributes_for :ship_address
  accepts_nested_attributes_for :payments
  # accepts_nested_attributes_for :shipments


  attr_accessor :shipping_method
  scope :complete, -> { where.not(completed_at: nil).where(approved_at: nil).where(canceled_at: nil) }
  scope :approved, -> { where.not(approved_at: nil).where(canceled_at: nil)}
  scope :canceled, -> { where.not(canceled_at: nil).where(approved_at: nil)}
  scope :shipped, -> { where(shipment_state: :shipped )}


  def self.incomplete
    where(completed_at: nil)
  end

  def prefix
    Order::PREFIX
  end

  def can_approve?
    completed? && state != 'approved'
  end

  def can_cancel?
    state == 'approved'
  end

  def approved?
    state == 'approved'
  end

  def self.checkout_steps
    CHECKOUT_STEPS.keys
  end

  def can_resume?
    state == 'canceled'
  end

  def cart?
    !completed?
  end

  def you_saved
    line_items.collect { |item| item.product.discount_amount }.sum
  end

  def net_total
    if shipment.present?
      ((total || 0) + (shipment.cost || 0)) - (adjustment_total || 0)
    else
      if adjustment_total.present?
        total - adjustment_total
      else
        total
      end
    end
  end

  def adjustment_total_value
    if adjustment_total.present?
      adjustment_total
    end
  end

  def checkout_allowed?
    line_items.count > 0
  end

  def shipment_cost
    shipment.present? ? shipment.cost : 0
  end

  def get_shipment_status
    if %w[delivered canceled refunded].include? shipment_state
      Order::ORDER_ALL_SHIPMENT_STATE
    else
      Order::ORDER_SHIPMENT_STATE
    end
  end

  def next
    if state == 'delivery'
      self.state = 'payment'
    elsif state == 'address'
      self.state = 'delivery'
    end
    save
  end

  def contents
    @contents ||= OrderContents.new(self)
  end

  def update_with_payment(payment_params)
    payment = make_payment(payment_params)
    unless payment.errors.any?
      self.completed_at = Time.now
      self.state = 'completed'
      self.shipment_state = 'shipped'
      self.payment_state = 'paid'
      self.payment_total = payment.amount
      if save
        remove_stock_from_inverntory
      end
    end
  end

  def approved_order(current_user)
    self.approver_id = current_user.id
    self.approved_at = Time.now
    self.shipment_progress = 100
    self.shipment_date = Date.today
    self.shipped_at = Time.now
    self.state = 'approved'
    self.save!
  end


  def update_with_params(params, permitted_params)
    if params[:state] == 'address'
      status = update!(permitted_params.merge({state: 'address'}))
      add_ship_id_to_user if status
      status
    elsif params[:state] == 'delivery'
      if init_shipment(permitted_params.delete(:shipping_method))
        update(permitted_params.merge(shipment_state: 'pending'))
      end
    elsif params[:state] == 'payment'
      payment = build_payment(permitted_params)
      unless payment.errors.any?
        self.completed_at = Time.now
        self.state = 'completed'
        self.shipment_state = Order::ORDER_SHIPMENT_STATE[:pending]
        self.payment_state = payment.state == 'completed' ? 'completed' : 'balance_due'
        if save
          remove_stock_from_inverntory
          deliver_order_confirmation_email unless confirmation_delivered?
        end
      end
    end
  end

  def remove_stock_from_inverntory
    if shipment.stock_location.present?
      stock_location = shipment.stock_location
      line_items.each do |line_item|
        stock_location.unstock(line_item.product,line_item.quantity, shipment)
      end
    end
  end

  def completed?
    !completed_at.blank?
  end

  def backdoor?
    admin_id.present?
  end

  def self.get_incomplete_order(token, user)
    order = where('guest_token = ? and completed_at IS NULL', token).last
    if user.present? && !order.present?
      order = user.orders.where('completed_at IS NULL').last
    end
    order
  end

  def deliver_order_confirmation_email
    OrderMailer.confirm_email(id).deliver_now # TODO: will send email after getting smtp credential
    update_column(:confirmation_delivered, true)
    update_column(:shipment_state, nil)
  end

  def self.result(params, orders)
    params_hash = {}
    if params[:order].present?
      if params[:order][:created_at_gt].present? && params[:order][:created_at_lt].present?
        from_date = params[:order][:created_at_gt].to_date
        to_date = params[:order][:created_at_lt].to_date
        params_hash[:created_at_gt] = params[:order][:created_at_gt]
        params_hash[:created_at_lt] = params[:order][:created_at_lt]
        orders = orders.where(created_at: from_date.beginning_of_day..to_date.end_of_day)
      elsif params[:order][:created_at_gt].present?
        # from_date = Time.strptime(params[:order][:created_at_gt], '%m/%d/%Y')
        params_hash[:created_at_gt] = params[:order][:created_at_gt]
        orders = orders.where(created_at: params[:order][:created_at_gt].to_date.beginning_of_day..params[:order][:created_at_gt].to_date.end_of_day)
      elsif params[:order][:created_at_lt].present?
        to_date = params[:order][:created_at_lt].to_date
        params_hash[:created_at_lt] = params[:order][:created_at_lt]
        orders = orders.where(created_at: to_date.beginning_of_day..to_date.end_of_day)
      end
      if params[:order][:number].present?
        params_hash[:number] = params[:order][:number]
        orders = orders.where(number: params[:order][:number])
      end

      if params[:order][:state].present?
        params_hash[:state] = params[:order][:state]
        orders = orders.where(state: params[:order][:state])
      end

      if params[:order][:payment_state].present?
        params_hash[:payment_state] = params[:order][:payment_state]
        orders = orders.where(payment_state: params[:order][:payment_state])
      end

      if params[:order][:email].present?
        params_hash[:email] = params[:order][:email]
        orders = orders.where(email: params[:order][:email])
      end

      if params[:order][:completed] == true
        params_hash[:completed] = params[:order][:completed]
        orders = orders.where(shipment_state: 'completed')
      end
    end
    result = { orders: orders, params_hash: params_hash }
    result
  end

  def collect_rewards_point
    if user.present? && approved_at.present?
      reward_point = user.rewards_points.find_or_initialize_by(order_id: id, user_id: user_id, reason: 'Checkout')
      reward_point.points = line_items.sum(&:credit_point)
      reward_point.save
    end
  end

  def init_shipment(shipping_method)
    shipping = ShippingMethod.find_by_id(shipping_method)
    u_shipment = shipment || build_shipment
    u_shipment.cost = shipping.rate.nil? ? 0 : shipping.rate
    u_shipment.address_id = ship_address.id
    u_shipment.tracking = shipping.code
    u_shipment.shipping_method_id = shipping.id
    u_shipment.state = 'pending'
    u_shipment.stock_location = StockLocation.active_stock_location
    u_shipment.save!
  end

  def build_payment(payments_attributes)
    payment_method_id = payments_attributes[:payments_attributes][:payment_method_id]
    payment_method = PaymentMethod.find_by_id(payment_method_id)
    return false unless payment_method.present?
    payment_params = payment_method.process
    payment_params[:amount] = net_total
    payment_params[:payment_method_id] = payment_method_id
    payment = payments.build(payment_params)
    if payment.save
      if payment_method.type == 'PaymentMethod::CreditPoint'
        RewardsPoint.create(order_id: id, points: net_total * -1, reason: "Purchased", user_id: user.id)
      end
    end

    payment
  end

  def approved_by(user)
    update(approver_id: user.id, approved_at: Time.current, canceled_at: nil, canceler_id: nil )
  end


  def canceled_by(user)
    update(canceler_id: user.id,  	canceled_at: Time.current, state: 'canceled', approved_at: nil, approver_id: nil )
  end

  def credit_rewards_point
    points = line_items.collect { |item| item.product.reward_point }.sum
    if points > 0
      reward_point = RewardsPoint.where(order_id: id, user_id: user_id).first
      if reward_point.present?
        reward_point.points = points
        reward_point.save
      else
        RewardsPoint.create(order_id: id, user_id: user_id, points: points, reason: 'Order Checkout Credit Points')
      end
    end
  end

  def make_payment(payments_params)
    payment_method_id = payments_params[:payment_method_id]
    payment_method = PaymentMethod.find_by_id(payment_method_id)
    return false unless payment_method.present?
    payment_params = payment_method.payment_process
    payment_params[:amount] = net_total
    payment_params[:payment_method_id] = payment_method_id
    payment = payments.build(payment_params)
    if payment.save
      if payment_method.type == 'PaymentMethod::CreditPoint'
        RewardsPoint.create(order_id: id, points: net_total * -1, reason: "Purchased", user_id: user.id)
      end
    end
    payment
  end

  def empty!
    if completed?
      raise t(:cannot_empty_completed_order)
    else
      updater = OrderUpdater.new(self)
      line_items.destroy_all
      updater.update_item_count
      shipment.destroy if shipment.present?

      updater.update_totals
      updater.persist_totals
      # restart_checkout_flow
    end
  end

  def add_ship_id_to_user
    if !user.nil? && !ship_address.nil?
      user.ship_address_id = ship_address.id
      user.save
    end
  end

  def check_shipment_status_for_send_mail
    ShipmentMailer.shipped_email(shipment).deliver_now if self.shipment_state == 'shipped'
  end

  # Add missing methods for OrderUpdater
  def canceled?
    canceled_at.present?
  end

  def completed?
    completed_at.present?
  end

  def outstanding_balance
    total - payment_total
  end

  def outstanding_balance?
    outstanding_balance == 0
  end

  def backordered?
    # Check if any line items are backordered
    line_items.any? { |item| item.backordered? }
  end

  def state_changed(attribute)
    # Placeholder method for state change notifications
    # Can be implemented later if needed
  end
end
