module Admin
  module Suppliers
    class PurchaseOrdersController < BaseController
      require 'barby'
      require 'chunky_png'
      require 'barby/barcode/code_128'
      require 'barby/outputter/png_outputter'

      before_action :set_purchase, only: [:cart, :return_item, :refund, :new_refund_items, :received_purchase, :update_receive_item, :complete, :update_purchase, :update_item, :add_item, :remove_item, :show, :edit, :update, :destroy, :receive, :refund ]
      before_action :check_stock_loaction, only: %i[create new_order refund ]

      def index
        @purchases = Admin::Suppliers::Invoice.purchase_orders.order(created_at: :desc)
        @purchases = @purchases.page(params[:page]).per(20)
      end
      def refunds
        @suppliers = User.suppliers
        @refunds = Admin::Suppliers::Refund.where(is_order: true).order(created_at: :desc)
        if params[:q].present?
          @refunds = Admin::Suppliers::Refund.search(params[:q], @refunds)
        end

        @refunds = @refunds.page(params[:page]).per(20)
      end

      def update_purchase
        @purchase.order_state = Admin::Suppliers::Invoice::ORDER_STATES[:complete][:data]
        @purchase.date = params[:date]
        @purchase.expected_delivery = params[:expected_date]
        @purchase.stock_location_id = params[:stock_location_id]
        @purchase.instruction = params[:instruction]
        @purchase.is_order = true
        if @purchase.save
          redirect_to  admin_suppliers_purchase_orders_path , notice: "Purchase Order Updated Successfully"
        end
      end

      def new_order
        @stock_locations = StockLocation.all
        @suppliers = User.suppliers
        @supplier = @suppliers.find_by_id(params[:supplier_id]) if params[:supplier_id]
        @purchase = current_purchase_order(true ,@supplier.id) if @supplier
        p @purchase
        redirect_to cart_admin_suppliers_purchase_order_path(@purchase) if @purchase

      end

      def show
        @supplier = @purchase.supplier
      end

      def destroy
        @purchase.destroy
        redirect_to admin_suppliers_purchase_orders_path , notice: "Purchase Order Destroyed"
      end

      def cart
        @supplier = User.suppliers.find_by(id: @purchase.supplier_id)
      end

      def complete
        @supplier = User.suppliers.find_by(id: @purchase.supplier_id)
        @stock_locations = StockLocation.all
        unless @purchase.items.exists?
          redirect_to cart_admin_suppliers_purchase_order_path(@purchase), notice: "Add Product First"
          #render 'cart'
        end
      end

      def add_item
        if params[:variant_id].present?
          variant = Product.find_by(id: params[:variant_id])
        end

        redirect_to cart_admin_suppliers_purchase_order_path(@purchase) and return unless variant.present?
        quantity = params[:quantity].to_i
        p quantity
        vat = params[:vat].to_f
        p vat
        purchase_item = @purchase.items.find_by_product_id(variant.id)
        if purchase_item
          purchase_item.issued_quantity += quantity
          purchase_item.total += purchase_item.cost_price * quantity
          purchase_item.save!
          @purchase_item = purchase_item
        else
          @purchase_item = @purchase.items.build
          @purchase_item.add_sale_quantity_total(variant, vat, quantity)
        end

        p @purchase_item
        if @purchase_item
          @purchase.invoice_amount
          redirect_to cart_admin_suppliers_purchase_order_path(@purchase)
        end
      end

      def update_item
        purchase_item = @purchase.items.find_by_id(params[:item_id])
        quantity = params[:quantity].to_i
        cost_price = params[:cost_price].to_f
        sale_price = params[:sale_price].to_f
        vat = params[:vat].to_f
        if purchase_item && quantity != purchase_item.issued_quantity
          if quantity > purchase_item.issued_quantity
            new_quantity = quantity - purchase_item.issued_quantity
            purchase_item.issued_quantity += new_quantity
            purchase_item.total += purchase_item.cost_price * new_quantity
            purchase_item.save!
            p purchase_item
          elsif quantity < purchase_item.issued_quantity && quantity > 0
            purchase_item.issued_quantity = quantity
            purchase_item.total = (purchase_item.cost_price * quantity).abs
            purchase_item.save!
            p purchase_item
          else
            redirect_to cart_admin_suppliers_purchase_order_path(@purchase) and return unless quantity.present?
          end
        end
        if purchase_item && cost_price != purchase_item.cost_price

          purchase_item.cost_price = cost_price
          purchase_item.total = purchase_item.issued_quantity * cost_price
          purchase_item.sale_price = cost_price + ((purchase_item.vat * cost_price) / 100.0 )
          purchase_item.save!
        elsif purchase_item && sale_price != purchase_item.sale_price
            purchase_item.sale_price = sale_price
            purchase_item.vat = (((sale_price - purchase_item.cost_price) *  100.0 ) / cost_price)
            purchase_item.save!
        elsif purchase_item && vat != purchase_item.vat
            purchase_item.vat = vat
            purchase_item.sale_price = (purchase_item.cost_price + ((vat * purchase_item.cost_price) / 100.0))
            purchase_item.save!
        end

        @purchase_item = purchase_item
        if @purchase_item
          @purchase.invoice_amount
          redirect_to cart_admin_suppliers_purchase_order_path(@purchase)
        end


      end

      def remove_item
        @purchase_item = @purchase.items.find_by_id(params[:item_id])
        if @purchase_item
          @purchase.amount -= @purchase_item.total
          @purchase.save!
          @purchase_item.destroy
          redirect_to cart_admin_suppliers_purchase_order_path(@purchase), notice: 'Product removed from purchase order'
        end
      end

      def receive
        @supplier = @purchase.supplier
      end

      def received_purchase
        @payment = @purchase.payments.build
        @payment.supplier = @purchase.supplier
        @payment.paid_by = current_user
        @payment.method = params[:payment_method]
        @payment.amount = params[:amount].to_f
        @payment.payment_date = params[:date] || Date.today
        @payment.supplier_payment_complete
        if @payment.save!
          @purchase.is_received = true
          @purchase.receive_date = Date.today
          @purchase.received_by = current_user
          @purchase.order_state = Admin::Suppliers::Invoice::ORDER_STATES[:received][:data]
          @purchase.amount = @payment.amount
          if @purchase.save!
            @purchase.items.each do |item|
              unless item.received_quantity.present?
                item.received_quantity = item.issued_quantity
                item.save!
              end
            end
            redirect_to admin_suppliers_purchase_orders_path , notice: "Purchase Order Received Successfully"
          end
        end

      end

      def update_receive_item
        purchase_item = @purchase.items.find_by_id(params[:item_id])
        quantity = params[:quantity].to_i
        cost_price = params[:cost_price].to_f
        sale_price = params[:sale_price].to_f
        vat = params[:vat].to_f
        purchase_quantity = (purchase_item.received_quantity ? purchase_item.received_quantity : purchase_item.issued_quantity )
        if purchase_item && quantity != purchase_quantity
          if quantity > purchase_quantity
            new_quantity = quantity - purchase_quantity
            purchase_item.increase_receive_quantity(new_quantity)
          elsif quantity < purchase_quantity && quantity > 0
            purchase_item.decrease_receive_quantity(quantity)
          else
            redirect_to receive_admin_suppliers_purchase_order_path(@purchase, bool: false) and return unless quantity.present?
          end
        end
        if purchase_item && cost_price != purchase_item.cost_price
          purchase_item.change_cost_price(cost_price)
        elsif purchase_item && sale_price != purchase_item.sale_price
          purchase_item.change_sale_price(sale_price)
        elsif purchase_item && vat != purchase_item.vat
          purchase_item.change_vat(vat)
        end
        @purchase_item = purchase_item
        if @purchase_item
          redirect_to receive_admin_suppliers_purchase_order_path(@purchase)
        end
      end

      def remove_receive_item

      end

      def refund
        @supplier = @purchase.supplier
        @refund = @purchase.order_refund
      end

      def new_refund_items
        @refund = @purchase.order_refund
        invoice_item = @purchase.items.find(params[:item_id])
        @max_quantity = invoice_item.received_quantity - invoice_item.return_item_count
        @product = invoice_item.product
      end

      def return_item
         @refund = @purchase.order_refund
         if @refund.present?
           @refund.update_attributes(refund_reason: params[:reason])
         else
           @refund = @purchase.refunds.create!(supplier: @purchase.supplier, invoice_no: @purchase.no, amount: 0, date: Date.today, refund_by: current_user.name, refund_reason: params[:reason], is_order: true)
         end
         @invoice_item = @purchase.items.find(params[:item_id])
         p @invoice_item
         quantity = params[:quantity].present? ? params[:quantity].to_i : 1
         @refund_item = @refund.items.create!(invoice_item_id: @invoice_item.id, amount: @invoice_item.cost_price * quantity, quantity: quantity)
         @refund.calculate_refund_amount
        if @refund
          redirect_to refund_admin_suppliers_purchase_orders_path(id: @purchase.id )
        end


      end

      private
      def set_purchase
        @purchase = Admin::Suppliers::Invoice.find(params[:id])
      end

      def purchase_params
        params.require(:admin_suppliers_invoice).permit!
      end
    end
  end
end

