class AddColumnImageToBrands < ActiveRecord::Migration[5.2]
  def change
    add_column :admin_brands, :image, :string
  end
end
