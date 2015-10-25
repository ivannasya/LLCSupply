class AddDriverIdLoad < ActiveRecord::Migration
  def change
    add_reference :loads, :driver, index: true
  end
end
