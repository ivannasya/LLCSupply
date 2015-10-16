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

ActiveRecord::Schema.define(version: 20151014164504) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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
  end

  create_table "points", force: true do |t|
    t.string "name"
    t.string "raw_line_1"
    t.string "city"
    t.string "state"
    t.string "zip"
    t.string "country"
  end

end
