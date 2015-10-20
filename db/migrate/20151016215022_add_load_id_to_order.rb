class AddLoadIdToOrder < ActiveRecord::Migration
  def change
    add_reference :orders, :load, index: true
    add_column :orders, :origin_number, :integer
    add_column :orders, :destination_number, :integer
  end
end