# frozen_string_literal: true

class AddSourceIdFieldToPayments < ActiveRecord::Migration[5.2]
  def change
    add_column :payments, :source_id, :integer
    add_column :payments, :source_type, :string
  end
end
