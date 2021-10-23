module Admin
  module Suppliers
    class RefundsController < BaseController
      before_action :set_refund, only: [:show, :edit, :update, :destroy, :edit_refund, :remove_refund_item, :remove_refund, :refund, :new_return_item, :refund_items]

      def index
        supplier_ids = User.suppliers.map(&:id)
        @refunds = Admin::Suppliers::Refund.where(supplier_id: supplier_ids).includes(:supplier).order(date: :desc)
        @refunds = @refunds.page(params[:page]).per(20)
      end

      def show
      end

      def new
        if params[:state].present? && params[:state] == 'order'
          @refund = Admin::Suppliers::Refund.new
          # @refund.items.build
          @suppliers = User.suppliers
          @supplier = @suppliers.find_by_id(params[:supplier_id]) if params[:supplier_id].present?
        else
          @invoices = Admin::Suppliers::Invoice.invoices
          @invoice = @invoices.find_by_id(params[:invoice_id])
          @refund = Admin::Suppliers::Refund.new(invoice_id: @invoice.id) if @invoice
        end
      end

      def new_refund
        @suppliers = User.suppliers
        if params[:supplier_id].present?
          @supplier = @suppliers.find_by_id(params[:supplier_id])
          @refund = Admin::Suppliers::Refund.create!(supplier_id: @supplier.id, refund_by: current_user.name, amount: 0, date: Date.today)
          redirect_to refund_admin_suppliers_refunds_path(id: @refund.id)
        end

      end

      def refund
        @supplier = @refund.supplier
        @purchases = Admin::Suppliers::Invoice.where(supplier_id: @supplier.id).received

      end

      def update_refund
        @refund = Admin::Suppliers::Refund.find(params[:id])
        @refund.date = params[:date]
        @refund.refund_reason = params[:refund_reason]
        @refund.is_order = true
        @refund.save!
        if @refund
          redirect_to refunds_admin_suppliers_purchase_orders_path
        end
      end

      def refund_items
        @purchase = Admin::Suppliers::Invoice.find_by(id: params[:invoice_id])
        invoice_item = @purchase.items.find(params[:invoice_item_id])
        @max_quantity = invoice_item.received_quantity - invoice_item.return_item_count
        @product = invoice_item.product
      end

      def new_return_item
        @purchase = Admin::Suppliers::Invoice.find_by(id: params[:invoice_id])
        @invoice_item = @purchase.items.find(params[:invoice_item_id])
        quantity = params[:quantity].present? ? params[:quantity].to_i : 1
        @refund_item = @refund.items.create!(invoice_item_id: @invoice_item.id, amount: @invoice_item.cost_price * quantity, quantity: quantity , product_id: params[:product_id])
        @refund.calculate_refund_amount
        if @refund
          redirect_to refund_admin_suppliers_refunds_path(id: @refund.id)
        end
      end

      def remove_refund
        @refund.destroy
        redirect_to refunds_admin_suppliers_purchase_orders_path
      end

      def edit_refund
        @supplier = @refund.supplier
        @purchases = Admin::Suppliers::Invoice.where(supplier_id: @supplier.id).received
      end

      # def remove_refund_item
      #   @refund_item = @refund.items.find(params[:item_id])
      #   @refund_item.destroy
      #   redirect_to edit_refund_admin_supplier_refunds_path(id: @refund.id)
      # end

      def edit
      end

      def create
          @invoice = Admin::Suppliers::Invoice.find_by_id(refund_params[:invoice_id])
          @refund = @invoice.refunds.build(refund_params.merge(supplier_id: @invoice.supplier_id))
          if @refund.save
            if @invoice.due_amount <= 0
              @invoice.is_complete = true
            else
              @invoice.is_complete = false
            end
            @invoice.save
            redirect_to new_admin_suppliers_payment_path(invoice_id: @invoice.id)
          else
            render :new, invoice_id: @invoice.id
          end
      end

      def update
        respond_to do |format|
          if @refund.update(refund_params)
            format.html { redirect_to @refund, notice: 'Refund was successfully updated.' }
            format.json { render :show, status: :ok, location: @refund }
          else
            format.html { render :edit }
            format.json { render json: @refund.errors, status: :unprocessable_entity }
          end
        end
      end

      def destroy
        @refund.destroy
        respond_to do |format|
          format.html { redirect_to admin_suppliers_refunds_url, notice: 'Refund was successfully destroyed.' }
          format.json { head :no_content }
        end
      end

      private

      def set_refund
        @refund = Admin::Suppliers::Refund.find(params[:id])
      end

      def refund_params
        params.require(:admin_suppliers_refund).permit!
      end
    end
  end
end

