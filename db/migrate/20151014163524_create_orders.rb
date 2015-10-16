class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.date :delivery_date
      t.string :shift
      t.references :origin
      t.references :destination
      t.string :phone_number
      t.string :mode
      t.string :order_number
      t.float :volume
      t.integer :handling_unit_quantity
      t.string :handling_unit_type
    end
  end
end
