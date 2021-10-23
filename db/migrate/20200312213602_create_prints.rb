class CreatePrints < ActiveRecord::Migration[5.2]
  def change
    create_table :prints do |t|

      t.timestamps
    end
  end
end
