module Admin
  module Orders
    class CustomersController < BaseController
      respond_to? :html
      before_action :set_order, only:[:show, :update]

      def show

      end

      def update

        p @order
        p "***********************************************"

        if @order.update(order_attributes)
          p @order
          p "***********************************************"
          redirect_to admin_order_customer_path
        else
          p @order
          p "***********************************************"
          p "***********************************************"
          p "***********************************************"
          redirect_to admin_order_customer_path
        end
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
