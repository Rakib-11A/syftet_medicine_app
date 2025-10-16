# frozen_string_literal: true

class CreatePrints < ActiveRecord::Migration[5.2]
  def change
    create_table :prints, &:timestamps
  end
end
