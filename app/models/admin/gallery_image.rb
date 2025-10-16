# frozen_string_literal: true

module Admin
  class GalleryImage < ApplicationRecord
    self.table_name = 'admin_gallery_images'

    mount_uploader :image, Admin::HomeSliderUploader

    validates :image, presence: true
  end
end
