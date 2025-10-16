# frozen_string_literal: true

class CreateImages < ActiveRecord::Migration[5.2]
  def change
    create_table :images do |t|
      t.references :viewable, polymorphic: true
      t.integer :width
      t.integer :height
      t.integer :file_size
      t.integer :position
      t.string :content_type
      t.text :file
      t.string :alt

      t.timestamps
    end
  end
end
