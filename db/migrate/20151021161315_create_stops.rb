class CreateStops < ActiveRecord::Migration
  def change
    create_table :stops do |t|
      t.references :point, index: true
      t.references :load, index: true
      t.integer :number
    end
  end
end
