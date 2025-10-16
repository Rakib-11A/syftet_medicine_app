# frozen_string_literal: true

module Admin
  class CategoryImageUploader < CarrierWave::Uploader::Base
    # Include RMagick or MiniMagick support:
    include CarrierWave::RMagick

    # Choose what kind of storage to use for this uploader:
    storage :file

    # Override the directory where uploaded files will be stored.
    def store_dir
      "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    end

    # Create different versions of your uploaded files:
    version :thumb do
      process resize_to_fit: [150, 150]
    end

    version :medium do
      process resize_to_fit: [300, 300]
    end

    version :large do
      process resize_to_fit: [600, 600]
    end

    # Add a white list of extensions which are allowed to be uploaded.
    def extension_whitelist
      %w[jpg jpeg gif png]
    end

    # Provide a default URL as a default if there hasn't been a file uploaded:
    def default_url(*_args)
      ActionController::Base.helpers.asset_path("fallback/#{[version_name, 'default.png'].compact.join('_')}")
    end
  end
end
