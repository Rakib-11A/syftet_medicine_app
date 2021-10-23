module Admin
  class GalleryImagesController < BaseController
    before_action :set_admin_gallery_image, only: [:show, :edit, :update, :destroy]

    # GET /admin/gallery_images
    def index
      @gallery_images = Admin::GalleryImage.all.order(:position)
      @gallery_images = @gallery_images.page(params[:page]).per(20)
    end

    # GET /admin/gallery_image/1
    def show
    end

    # GET /admin/gallery_image/new
    def new
      @gallery_image = Admin::GalleryImage.new
    end

    # GET /admin/gallery_images/1/edit
    def edit
    end

    # POST /admin/gallery_images
    def create
      @gallery_image = Admin::GalleryImage.new(admin_gallery_image_params)

      respond_to do |format|
        if @gallery_image.save
          format.html { redirect_to admin_gallery_images_path, notice: 'Image was successfully added to gallery.' }
          format.json { render :show, status: :created, location: @gallery_image }
        else
          format.html { render :new }
          format.json { render json: @gallery_image.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /admin/gallery_images/1
    def update
      respond_to do |format|
        if @gallery_image.update(admin_gallery_image_params)
          format.html { redirect_to admin_gallery_images_path, notice: 'Image was successfully updated.' }
          format.json { render :show, status: :ok, location: @gallery_image }
        else
          format.html { render :edit }
          format.json { render json: @gallery_image.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /admin/gallery_images/1
    def destroy
      respond_to do |format|
        if @gallery_image.destroy
          format.html { redirect_to admin_gallery_images_url, notice: 'Image was successfully removed from gallery.' }
        else
          format.html { redirect_to admin_gallery_images_url, notice: 'Unable to remove image.' }
        end
      end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_admin_gallery_image
      @gallery_image = Admin::GalleryImage.find(params[:id])
    end

    def admin_gallery_image_params
      params.require(:admin_gallery_image).permit(:image, :position)
    end
  end
end
