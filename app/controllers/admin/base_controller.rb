module Admin
  class BaseController < ApplicationController
    layout 'layouts/admin'

    before_action :authorize_admin
    helper_method :current_admin_order
    helper_method :current_purchase_order

    rescue_from CanCan::AccessDenied do |exception|
      flash[:error] = exception.message
      redirect_to root_url
    end

    def current_admin_order(create_order = false)
      if create_order && @order.blank?
        order = Order.new
        order.guest_token = get_token
        order.admin_id = current_user.id if current_user.present?
        order.state = 'address'
        order.store = StockLocation.active_stock_location
        order.save!
        @order = order
      end
      unless @order.present? && @order.completed?
        @order
      end
    end

    def current_purchase_order(create_order = false, supplier_id)
      if create_order && supplier_id && @purchase.blank?
        supplier = User.suppliers.find_by(id: supplier_id)
        purchase = Admin::Suppliers::Invoice.new
        purchase.date = Date.today
        purchase.supplier = supplier
        purchase.issued_by = current_user
        purchase.amount = 0
        purchase.save!
        purchase.generate_invoice_no
        @purchase = purchase
      end
    end
    protected

    def action
      params[:action].to_sym
    end

    def authorize_admin
      if respond_to?(:model_class, true) && model_class
        record = model_class
      else
        record = controller_name.to_sym
      end
      authorize! :admin, record
      authorize! action, record
    end
    def check_stock_loaction
      redirect_to new_stock_location_path, notice: 'First Create Stock Location' unless StockLocation.present?
    end
  end
end
