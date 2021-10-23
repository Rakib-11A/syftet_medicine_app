class CreateRewardsPoints < ActiveRecord::Migration[5.2]
  def change
    create_table :rewards_points do |t|
      t.integer :order_id
      t.decimal :points, default: 0.0, precision: 22, scale: 6
      t.string :reason
      t.integer :user_id

      t.timestamps
    end
  end
end
