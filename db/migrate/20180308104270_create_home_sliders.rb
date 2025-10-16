# frozen_string_literal: true

class CreateHomeSliders < ActiveRecord::Migration[5.2]
  def change
    create_table :home_sliders do |t|
      t.string :image

      t.timestamps
    end
  end
end
