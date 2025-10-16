# frozen_string_literal: true

# == Schema Information
#
# Table name: admin_categories
#
#  id          :integer          not null, primary key
#  name        :string
#  slug        :string
#  description :string
#  permalink   :string
#  meta_title  :string
#  meta_desc   :string
#  keywords    :string
#  parent_id   :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  image       :string
#

module Admin
  class Category < ApplicationRecord
    extend FriendlyId
    friendly_id :name, use: :slugged
    validates_length_of :name, maximum: 255
    validates_length_of :description, maximum: 255
    self.table_name = 'admin_categories'

    # Add CarrierWave mount for image uploads
    mount_uploader :image, Admin::CategoryImageUploader

    after_save :set_permalink

    has_many :sub_categories, class_name: 'Admin::Category', foreign_key: :parent_id, dependent: :destroy
    belongs_to :category, class_name: 'Admin::Category', foreign_key: :parent_id, required: false
    has_many :product_categories, dependent: :destroy
    has_many :products, through: :product_categories

    # Add image_url method for different sizes
    def image_url(size = :thumb)
      if image.present?
        image.url(size)
      else
        # Default placeholder image if no image is uploaded
        '/assets/fallback/empty_product.svg'
      end
    end

    private

    def set_permalink
      return unless permalink.blank?

      self.permalink = name.parameterize
      save
    end

    def self.menu
      where('parent_id is NULL')
    end

    # def self.parent
    # self.where('parent_id is present')
    # end

    def self.menu
      where('parent_id is NULL')
    end
  end
end
