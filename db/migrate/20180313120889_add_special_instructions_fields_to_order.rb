# frozen_string_literal: true

class AddSpecialInstructionsFieldsToOrder < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :special_instructions, :text
  end
end
