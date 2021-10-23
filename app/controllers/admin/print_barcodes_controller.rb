module Admin
  class PrintBarcodesController < BaseController

    require 'barby'
    require 'chunky_png'
    require 'barby/barcode/code_128'
    require 'barby/outputter/png_outputter'


    include CurrentPrint
    before_action :set_print, only: [:create]
    before_action :set_print_barcode, only: [:show, :edit, :update, :destroy]


    def index
      @print_barcodes = PrintBarcode.where(user: current_user)
    end

    def edit

    end

    def new

    end

    def create
      product = Product.find_by_id(params[:print_barcode][:product_id])
      quantity = params[:print_barcode][:quantity]
      @print_barcode = @print.print_barcodes.build(product: product)
      @print_barcode = @print.add_product(product , quantity)
      @print_barcode.user_id = current_user.id
      if @print_barcode.save
          redirect_to edit_admin_product_path(product)
      end
    end

    def update
      respond_to do |format|
        if @print_barcode.update(print_barcode_params)
          format.html { redirect_to admin_print_barcodes_path, notice: 'PrintBarcode updated successfully.' }
        else
          format.html { render :edit }
        end
      end
    end

    def destroy
      if @print_barcode.destroy
        flash[:notice] = 'PrintBarcode deleted successfully.'
      else
        flash[:error] = 'Unable to deleted PrintBarcode.'
      end
      redirect_to admin_print_barcodes_path
    end

    def preview
      @barcode_images = {}
      @print_barcodes = current_user.print_barcodes
      @print_barcodes.each do |print_barcode|
        if print_barcode.product.present?
          code = print_barcode.product.barcode.present? ? print_barcode.product.barcode : print_barcode.product.code
          barcode = Barby::Code128B.new(code).to_png(margin: 2, height: 30, width: 150 )
          @barcode_images[print_barcode.id] = Base64.encode64(barcode.to_s).gsub(/\s+/, "")
        end
      end
      puts params[:page_type]
      if params[:page_type] == "A4"
        render layout: 'print_barcode_A4'
      else
        render layout: 'print_barcode_thermal'
      end
    end

    private

    def set_print_barcode
      @print_barcode = PrintBarcode.find(params[:id])
    end

    def print_barcode_params
      params.require(:print_barcode).permit(:product_id, :quantity)
    end
  end
end

