class AddIsCheckedToContacts < ActiveRecord::Migration[5.2]
  def change
    add_column :contacts, :is_checked, :boolean, default: false
    add_reference :contacts, :user, foreign_key: true
  end
end
