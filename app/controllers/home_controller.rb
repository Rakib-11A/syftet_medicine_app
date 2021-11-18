class HomeController < ApplicationController
  def index
    @featured_products = Product.featured_products.includes(:reviews).order(id: :desc)
    # @new_arrivals = Product.new_arrivals.includes(:reviews)
    @new_arrivals = Product.where(discountable: true).includes(:reviews)
    @feedbacks = Feedback.order(id: :desc).limit(5)
    @blogs = Blog.all.order(:created_at).limit(3)
    @brands = Admin::Brand.where(is_active: true).where.not(image: nil).limit(12)
    @gallery_images = Admin::GalleryImage.all.order(:position).limit(20)
    @sliders = HomeSlider.all #.order(:position)
  end

  def sitemap
    @products = Product.all
    @domain = "#{request.protocol}#{request.host_with_port}"
  end
end
