module Admin
  class ShippingMethodsController < BaseController
    before_action :set_shipping_method, only: [:edit, :update, :destroy]

    def index
      @shipping_methods = ShippingMethod.all.order(created_at: :desc)
      @shipping_methods = @shipping_methods.page(params[:page]).per(20)
    end

    def new
      @shipping_method = ShippingMethod.new
    end

    def create
      @shipping_method = ShippingMethod.new(shipping_method_params)
      if @shipping_method.save
        redirect_to admin_shipping_methods_path
      else
        render :new
      end
    end

    def edit
    end

    def update
      if @shipping_method.update_attributes(shipping_method_params)
        flash[:success] = "Shipping method updates"
        redirect_to admin_shipping_methods_path
      else
        render :edit
      end
    end

    def destroy
      @shipping_method.destroy
      flash[:success] = 'successfully removed'
      redirect_to admin_shipping_methods_path
    end

    private

    def shipping_method_params
      params.require(:shipping_method).permit!
    end

    def set_shipping_method
      @shipping_method = ShippingMethod.find_by_id(params[:id])
    end

  end
end