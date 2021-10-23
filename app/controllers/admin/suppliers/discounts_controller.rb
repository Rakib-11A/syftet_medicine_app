module Admin
  module Suppliers
    class DiscountsController < BaseController
      before_action :set_admin_suppliers_discount, only: [:show, :edit, :destroy]

      # GET /admin/suppliers/discounts
      # GET /admin/suppliers/discounts.json
      def index
        @discounts = Admin::Suppliers::Discount.all.order(created_at: :desc)
        @discounts = @discounts.page(params[:page]).per(20)
      end

      # GET /admin/suppliers/discounts/1
      # GET /admin/suppliers/discounts/1.json
      def show
      end

      # GET /admin/suppliers/discounts/new
      def new
        @invoices = Admin::Suppliers::Invoice.invoices
        @invoice = @invoices.find_by_id(params[:invoice_id]) if params[:invoice_id]
        p @invoice
        @discount = Admin::Suppliers::Discount.new(invoice_id: @invoice.id) if @invoice
      end

      # GET /admin/suppliers/discounts/1/edit
      def edit
      end

      # POST /admin/suppliers/discounts
      # POST /admin/suppliers/discounts.json
      def create

        @invoice = Admin::Suppliers::Invoice.find_by_id(discount_params[:invoice_id])
        @discount = @invoice.discounts.build(discount_params.merge(supplier_id: @invoice.supplier_id))
        if @discount.save
          if @invoice.due_amount <= 0
            @invoice.is_complete = true
          else
            @invoice.is_complete = false
          end
          @invoice.save
          redirect_to admin_suppliers_discounts_path
        else
          @discount.errors
          render :new, invoice_id: @invoice.id
        end
      end

      # PATCH/PUT /admin/suppliers/discounts/1
      # PATCH/PUT /admin/suppliers/discounts/1.json
      def update
        @invoice = Admin::Suppliers::Invoice.find_by_id(discount_params[:invoice_id])
        @discount = @invoice.discounts.find_by_id(params[:id])
        @discount.update(discount_params.merge(supplier_id: @invoice.supplier_id))
        if @discount.save
          redirect_to admin_suppliers_discounts_path
        end
      end

      # DELETE /admin/suppliers/discounts/1
      # DELETE /admin/suppliers/discounts/1.json
      def destroy
        @discount.destroy
        respond_to do |format|
          format.html { redirect_to admin_suppliers_discounts_url, notice: 'Discount was successfully destroyed.' }
          format.json { head :no_content }
        end
      end

      private
      # Use callbacks to share common setup or constraints between actions.
      def set_admin_suppliers_discount
        @discount = Admin::Suppliers::Discount.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def discount_params
        params.require(:admin_suppliers_discount).permit(:amount, :date, :discount_by, :discount_reason, :invoice_no, :invoice_id, :supplier_id)
      end
    end
  end
end

