module Admin
  module Suppliers
    class PaymentsController < BaseController
        before_action :set_admin_suppliers_payment, only: [:show, :edit, :update, :destroy]

      # GET /admin/suppliers/payments
      # GET /admin/suppliers/payments.json
      def index
        @suppliers_payments = Admin::Suppliers::Payment.all.order(payment_date: :desc, created_at: :desc)
        @suppliers_payments = @suppliers_payments.page(params[:page]).per(20)
      end

      def show
      end

      def new
        @suppliers_payment = Admin::Suppliers::Payment.new(payment_date: Date.today)
      end

      def edit
      end

      def create
        @suppliers_payment = Admin::Suppliers::Payment.new(admin_suppliers_payment_params)

        respond_to do |format|
          if @suppliers_payment.save
            format.html { redirect_to @suppliers_payment, notice: 'Payment was successfully created.' }
            format.json { render :show, status: :created, location: @suppliers_payment }
          else
            format.html { render :new }
            format.json { render json: @suppliers_payment.errors, status: :unprocessable_entity }
          end
        end
      end

      def update
        respond_to do |format|
          if @suppliers_payment.update(admin_suppliers_payment_params)
            format.html { redirect_to @suppliers_payment, notice: 'Payment was successfully updated.' }
            format.json { render :show, status: :ok, location: @admin_suppliers_payment }
          else
            format.html { render :edit }
            format.json { render json: @suppliers_payment.errors, status: :unprocessable_entity }
          end
        end
      end

      def destroy
        @suppliers_payment.destroy
        respond_to do |format|
          format.html { redirect_to admin_suppliers_payments_url, notice: 'Payment was successfully destroyed.' }
          format.json { head :no_content }
        end
      end

      def complete
        payment = Admin::Suppliers::Payment.find_by_id(params[:id])
        date = payment.cash? ? payment.payment_date : payment.value_date
        @payments =   Admin::Suppliers::Payment.where("supplier_id = ? AND (payment_date = ? OR value_date = ?)", payment.supplier_id,date,date)
          @payments.each do |payment|
            payment.supplier_payment_complete
          end

        redirect_to action: :index
      end

      private
      # Use callbacks to share common setup or constraints between actions.
      def set_admin_suppliers_payment
        @suppliers_payment = Admin::Suppliers::Payment.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def admin_suppliers_payment_params
        params.require(:admin_suppliers_payment).permit(:supplier_id, :paid_by_id, :method, :amount, :payment_date, :value_date, :cheque_number, :status, :confirmed, :paid_to, :invoice_id, :bank_name, :bank_branch, :is_group_payment, :commission, :bank_account_id)
      end
    end
  end
end

