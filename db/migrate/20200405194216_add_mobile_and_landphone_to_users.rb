# frozen_string_literal: true

class AddMobileAndLandphoneToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :mobile, :string
    add_column :users, :landphone, :string
  end
end
