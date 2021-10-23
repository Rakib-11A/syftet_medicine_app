module Admin
  class DashboardController < BaseController
    def index
      @orders = Order.all.complete.order(completed_at: :desc).limit(10).first(10)
      @products = Product.new_arrivals.limit(10).first(10)
      @customers = User.new_customers.limit(10).first(10)
      @min_products = Product.stock_out_of_limit
    end

    def subscribers
      @subscribers = NewsletterSubscription.all.order(created_at: :desc)
      @subscribers = @subscribers.page(params[:page]).per(20)
    end

    def monthly_reports
      @orders = Order.all.shipped
      @purchases = Admin::Suppliers::Invoice.received
    end

    def purchase_reports
      @purchases = Admin::Suppliers::Invoice.received.order(created_at: :desc)
    end

    def sales_reports
      @orders = Order.all.shipped
    end
  end
end
