class AddLoadIdToOrder < ActiveRecord::Migration
  def change
    add_reference :orders, :load, index: true
  end
end
