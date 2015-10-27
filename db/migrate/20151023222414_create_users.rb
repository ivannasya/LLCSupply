class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :password_digest
      t.string :role
    end

    User.create username: 'dispatcher', role: 'dispatcher', password: 'dispatcher'
    User.create username: 'driver_one', role: 'driver_one', password: 'driver_one'
    User.create username: 'driver_two', role: 'driver_two', password: 'driver_two'
  end
end
