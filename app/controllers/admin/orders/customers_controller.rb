# frozen_string_literal: true

module Admin
  module Orders
    class CustomersController < BaseController
      respond_to? :html
      before_action :set_order, only: %i[show update]

      def show; end

      def update
        p @order
        p '***********************************************'

        p @order
        p '***********************************************'
        p '***********************************************' unless @order.update(order_attributes)
        p '***********************************************'
        redirect_to admin_order_customer_path
      end

      private

      def order_attributes
        params.require(:order).permit!
      end

      def set_order
        @order = Order.find_by_number(params[:order_id])
      end
    end
  end
end
