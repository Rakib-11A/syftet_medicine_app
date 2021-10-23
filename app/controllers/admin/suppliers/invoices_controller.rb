module Admin
  module Suppliers
    class InvoicesController < BaseController
        before_action :set_admin_suppliers_invoice, only: [:show, :edit, :update, :destroy]

      # GET /admin/suppliers/invoices
      # GET /admin/suppliers/invoices.json
      def index
        @suppliers_invoices = Admin::Suppliers::Invoice.all.order(created_at: :desc)
        @suppliers_invoices = @suppliers_invoices.page(params[:page]).per(20)
      end

      # GET /admin/suppliers/invoices/1
      # GET /admin/suppliers/invoices/1.json
      def show
      end

      # GET /admin/suppliers/invoices/new
      def new
        @suppliers_invoice = Admin::Suppliers::Invoice.new
        @suppliers_invoice.attachments.build
      end

      # GET /admin/suppliers/invoices/1/edit
      def edit
      end

      # POST /admin/suppliers/invoices
      # POST /admin/suppliers/invoices.json
      def create
        @suppliers_invoice = Admin::Suppliers::Invoice.new(admin_suppliers_invoice_params)

        respond_to do |format|
          if @suppliers_invoice.save
            format.html { redirect_to @suppliers_invoice, notice: 'Invoice was successfully created.' }
            format.json { render :show, status: :created, location: @suppliers_invoice }
          else
            format.html { render :new }
            format.json { render json: @suppliers_invoice.errors, status: :unprocessable_entity }
          end
        end
      end

      # PATCH/PUT /admin/suppliers/invoices/1
      # PATCH/PUT /admin/suppliers/invoices/1.json
      def update
        respond_to do |format|
          if @suppliers_invoice.update(admin_suppliers_invoice_params)
            format.html { redirect_to @suppliers_invoice, notice: 'Invoice was successfully updated.' }
            format.json { render :show, status: :ok, location: @suppliers_invoice }
          else
            format.html { render :edit }
            format.json { render json: @suppliers_invoice.errors, status: :unprocessable_entity }
          end
        end
      end

      # DELETE /admin/suppliers/invoices/1
      # DELETE /admin/suppliers/invoices/1.json
      def destroy
        @suppliers_invoice.destroy
        respond_to do |format|
          format.html { redirect_to admin_suppliers_invoices_url, notice: 'Invoice was successfully destroyed.' }
          format.json { head :no_content }
        end
      end

      def history
        @invoice = Admin::Suppliers::Invoice.find_by_id(params[:invoice_id])
      end

      def details
        @invoice = Admin::Suppliers::Invoice.find_by_id(params[:invoice_id])
        render layout: false
      end
      private
      # Use callbacks to share common setup or constraints between actions.
      def set_admin_suppliers_invoice
        @suppliers_invoice = Admin::Suppliers::Invoice.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def admin_suppliers_invoice_params
        params.require(:admin_suppliers_invoice).permit(:supplier_id, :no, :amount, :date, :transport_cost, attachments_attributes: [:id, :picture, :_destroy])
      end
    end
  end
end

