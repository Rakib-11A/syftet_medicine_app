class AddColumnPositionToHomeSliders < ActiveRecord::Migration[5.2]
  def change
    add_column :home_sliders, :position, :integer, default: 1
  end
end
