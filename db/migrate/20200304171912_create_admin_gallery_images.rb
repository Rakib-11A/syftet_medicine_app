# frozen_string_literal: true

class CreateAdminGalleryImages < ActiveRecord::Migration[5.2]
  def change
    create_table :admin_gallery_images do |t|
      t.string :image
      t.integer :position, default: 1

      t.timestamps
    end
  end
end
