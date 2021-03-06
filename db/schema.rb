# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20151024122433) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "loads", force: true do |t|
    t.string  "shift"
    t.date    "date"
    t.integer "driver_id"
  end

  add_index "loads", ["driver_id"], name: "index_loads_on_driver_id", using: :btree

  create_table "orders", force: true do |t|
    t.date    "delivery_date"
    t.string  "shift"
    t.integer "origin_id"
    t.integer "destination_id"
    t.string  "phone_number"
    t.string  "mode"
    t.string  "order_number"
    t.float   "volume"
    t.integer "handling_unit_quantity"
    t.string  "handling_unit_type"
    t.integer "origin_stop_id"
    t.integer "destination_stop_id"
    t.integer "load_id"
  end

  add_index "orders", ["load_id"], name: "index_orders_on_load_id", using: :btree

  create_table "points", force: true do |t|
    t.string "name"
    t.string "raw_line_1"
    t.string "city"
    t.string "state"
    t.string "zip"
    t.string "country"
  end

  create_table "stops", force: true do |t|
    t.integer "point_id"
    t.integer "load_id"
    t.integer "number"
  end

  add_index "stops", ["load_id"], name: "index_stops_on_load_id", using: :btree
  add_index "stops", ["point_id"], name: "index_stops_on_point_id", using: :btree

  create_table "users", force: true do |t|
    t.string "username"
    t.string "password_digest"
    t.string "role"
  end

end
