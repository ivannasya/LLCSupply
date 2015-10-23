class AddLoadIdToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :origin_stop_id, :integer
    add_column :orders, :destination_stop_id, :integer
    add_reference :orders, :load, index: true
  end
end