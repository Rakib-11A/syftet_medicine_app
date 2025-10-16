# frozen_string_literal: true

class AddIsCheckedToFeedbacks < ActiveRecord::Migration[5.2]
  def change
    add_column :feedbacks, :is_checked, :boolean, default: false
    add_reference :feedbacks, :user, foreign_key: true
  end
end
