class CreateLoads < ActiveRecord::Migration
  def change
    create_table :loads do |t|
      t.string :shift
      t.date :date
    end
  end
end
