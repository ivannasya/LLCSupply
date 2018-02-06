# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create username: 'dispatcher', role: 'dispatcher', password: 'dispatcher', password_confirmation: 'dispatcher'
User.create username: 'driver_one', role: 'driver_one', password: 'driver_one', password_confirmation: 'driver_one'
User.create username: 'driver_two', role: 'driver_two', password: 'driver_two', password_confirmation: 'driver_two'
