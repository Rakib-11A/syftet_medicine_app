# frozen_string_literal: true

module Admin
  class SuppliersController < UsersController
    before_action :set_supplier, only: %i[show statement edit update destroy address orders]
    def index
      @suppliers = supplier_collection.page(params[:page]).per(20)
      respond_to do |format|
        format.html
        format.json { render json: json_data }
      end
    end

    def new
      @supplier = User.new({ role: params[:role] })
    end

    def edit; end

    def show
      @invoices = @supplier.invoices.order(date: :desc)
      @discounts = @supplier.discounts.order(date: :desc)
      @refunds = @supplier.refunds.order(date: :desc)
      @payments = @supplier.payments.order(payment_date: :desc)
    end

    def create
      @supplier = User.new(user_params)
      respond_to do |format|
        if @supplier.save
          format.html { redirect_to admin_suppliers_path }
        else
          format.html { render action: :new }
        end
        format.js {}
      end
    end

    def update
      if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
        params[:user].delete(:password)
        params[:user].delete(:password_confirmation)
      end

      flash.now[:success] = t(:account_updated) if @supplier.update(user_params)

      render :edit
    end

    def destroy
      @supplier.destroy
      respond_to do |format|
        format.html { redirect_to admin_suppliers_path }
        format.js {}
      end
    end

    def purchase_list
      if params[:payment_date].present?
        payment_date = params[:payment_date]
        date = Date.new payment_date['date(1i)'].to_i, payment_date['date(2i)'].to_i, payment_date['date(3i)'].to_i
      else
        date = Date.today
      end
      supplier_ids = User.suppliers.map(&:id)
      @invoices = Admin::Suppliers::Invoice.where(supplier_id: supplier_ids, date: date).order(date: :desc)
    end

    def address
      return unless request.put?

      flash.now[:success] = t(:account_updated) if @supplier.update(user_params)
      render :address
    end

    def orders
      @orders = @supplier.orders
    end

    def get_history
      @supplier = User.find_by_id(params[:id]) || []
    end

    def process_invoice
      payment_method = params['payment_method']
      total_payment = 0
      payment_method.each do |key, value|
        next unless value.present?

        invoice = Admin::Suppliers::Invoice.find_by_id(key)
        payment = invoice.payments.build(supplier_id: params['supplier_id'])
        payment.amount = if params['invoice_pay'].present? && params['invoice_pay'][key].present?
                           invoice.due_amount
                         else
                           params['invoice_amount'][key]
                         end
        next unless payment.amount && payment.amount > 1

        payment.commission = params['invoice_commission'][key]
        payment.paid_by_id = params['cashier_id']
        payment.paid_to = params['paid_to']
        payment.method = value
        payment.payment_date = Date.parse(params[:received_date]) || Date.today
        if payment.save
          if invoice.due_amount <= 1
            invoice.is_complete = true
            invoice.save
          end
          payment.supplier_payment_complete if payment.cash?
          total_payment += payment.amount
        else
          puts error_messages(payment)
        end
      end
      supplier = User.find_by_id(params['supplier_id'])
      due = supplier.due_balance
      if  due.negative?
        total_payment
      elsif total_payment > due
        total_payment - due
      end
      redirect_to new_admin_suppliers_payment_path(supplier_id: params['supplier_id']), notice: 'Payment Successful'
    end

    private

    def set_supplier
      @supplier = User.find_by_id(params[:id])
    end
  end
end
