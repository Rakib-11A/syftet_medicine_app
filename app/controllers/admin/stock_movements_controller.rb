# frozen_string_literal: true

module Admin
  class StockMovementsController < BaseController
    before_action :set_stock_location

    def index
      @stock_movements = @stock_location.stock_movements.recent
      @stock_movements = @stock_movements.page(params[:page]).per(20)
    end

    def new
      @stock_movement = @stock_location.stock_movements.build
    end

    def create
      @stock_movement = @stock_location.stock_movements.build(stock_movement_params)
      respond_to do |format|
        if @stock_movement.save
          format.html do
            redirect_to admin_stock_location_stock_movements_path(@stock_location),
                        notice: 'Stock movement created successfully.'
          end
        else
          format.html do
            redirect_to admin_stock_location_stock_movements_path(@stock_location), notice: 'Unable to move stock.'
          end
        end
      end
    end

    def edit
      @stock_movement = StockMovement.find(params[:id])
    end

    private

    def set_stock_location
      @stock_location = StockLocation.find(params[:stock_location_id])
    end

    def stock_movement_params
      params.require(:stock_movement).permit(:quantity, :stock_item_id, :action)
    end
  end
end
