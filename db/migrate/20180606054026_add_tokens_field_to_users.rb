# frozen_string_literal: true

class AddTokensFieldToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :tokens, :text
  end
end
