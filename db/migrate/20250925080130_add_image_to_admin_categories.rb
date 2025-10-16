# frozen_string_literal: true

class AddImageToAdminCategories < ActiveRecord::Migration[8.0]
  def change
    add_column :admin_categories, :image, :string
  end
end
