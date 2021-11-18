module Admin
  class ProductsController < BaseController
    before_action :set_product, only: [:edit, :show, :update, :destroy, :stock, :remove_review, :review, :approved]

    def index
      @products = active_product.page(params[:page]).per(20)
      respond_to do |format|
        format.html {  }
        format.json { @products = Product.master_active.search_by_name_or_code(params[:q][:term]) }
      end
    end

    def new
      @product = Product.new(code: Product.generate_code)
    end

    def create
      @product = Product.new(product_params)
      respond_to do |format|
        if @product.save
          format.html {redirect_to edit_admin_product_path(@product), notice: 'Product created successfully.' }
        else
          format.html { render :new }
        end
      end
    end

    def edit
    end

    def show

    end

    def update
      respond_to do |format|
        if @product.update(product_params)
          format.html { redirect_to edit_admin_product_path(@product), notice: 'Product updated successfully.' }
        else
          format.html { render :edit }
        end
      end
    end

    def destroy
      if @product.destroy
        flash[:notice] = 'Product deleted successfully.'
      else
        flash[:error] = 'Unable to deleted product.'
      end
      redirect_to admin_products_path
    end

    def remove_review
      @product_review = @product.reviews.find(params[:review_id])
      p @product_review
      @product_review.destroy
      respond_to do |format|
        format.html { redirect_to admin_product_url(@product), notice: 'Review was successfully destroyed.' }
        format.json { head :no_content }
      end
    end

    def stock
      @products = @product.variants_with_master
      @stock_locations = StockLocation.active
      if @stock_locations.empty?
        flash[:error] = t(:stock_management_requires_a_stock_location)
        redirect_to admin_stock_locations_path
      end
    end

    def review

    end

    def approved
      @product_review = @product.reviews.find(params[:review_id])
      if @product_review
        @product_review.is_approved = true
        if @product_review.save
          redirect_to review_admin_product_path, notice: 'Review Approved Successfully'
        end
      else
        redirect_to review_admin_product_path , notice: 'No review Found'
      end

    end

    def inventory
      @products = Product.master_active
    end

    def name_search
      products = []
      params[:per_page] = 10
      products = Search.new(params).result.map{ |product| { id: product.id, text: product.name }} if params[:name].present?
      more = products.length >= params[:per_page]

      render json: {
          results: products,
          pagination: {
              more: more
          }
      }
    end

    private

    def set_product
      @product = Product.friendly.find(params[:id])
    end

    def product_params
      params.require(:product).permit(:code, :name, :description, :origin, :pre_order,
                                      :slug, :meta_title, :meta_desc, :keywords,
                                      :brand_id, :is_featured, :is_active,
                                      :deleted_at, :product_id, :sale_price,
                                      :cost_price, :whole_sale, :color_name,
                                      :color, :size, :weight, :width, :height,
                                      :depth, :discountable, :is_amount,
                                      :discount, :reward_point,
                                      :track_inventory, :barcode, :min_stock, :supplier_id, category_ids: [])
    end

    def active_product
      search Product.master_active
    end

    def search(products)
      @search = Product.new
      if params[:quick_search].present?
        query = params[:quick_search].downcase
        products.where("lower(name) like '%#{query}%' or lower(code) like '%#{query}%' or lower(barcode) like '%#{query}%'")
      elsif params[:product].present?
        @search = Product.new(product_params)
        products = products.where("lower(name) like '%#{params[:product][:name].downcase}%'") unless params[:product][:name].blank?
        products = products.where("lower(code) like '%#{params[:product][:code].downcase}%'") unless params[:product][:code].blank?
        products = products.where("lower(barcode) like '%#{params[:product][:barcode].downcase}%'") unless params[:product][:barcode].blank?
        products
      else
        products
      end


    end
  end
end
