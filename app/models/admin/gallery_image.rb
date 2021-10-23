class Admin::GalleryImage < ApplicationRecord
  self.table_name = 'admin_gallery_images'

  mount_uploader :image, Admin::HomeSliderUploader

  validates :image, presence: true
end
