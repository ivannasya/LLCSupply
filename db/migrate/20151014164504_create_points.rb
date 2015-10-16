class CreatePoints < ActiveRecord::Migration
  def change
    create_table :points do |t|
      t.string :name
      t.string :raw_line_1
      t.string :city
      t.string :state
      t.string :zip
      t.string :country
    end
  end
end
