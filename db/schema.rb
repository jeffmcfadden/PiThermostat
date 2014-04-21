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

ActiveRecord::Schema.define(version: 20140421212051) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "thermostat_histories", force: true do |t|
    t.integer  "thermostat_id"
    t.integer  "year"
    t.integer  "day_of_year"
    t.float    "low_temperature"
    t.float    "high_temperature"
    t.float    "mean_temperature"
    t.integer  "runtime"
    t.text     "json_archive"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "thermostat_histories", ["high_temperature"], name: "index_thermostat_histories_on_high_temperature", using: :btree
  add_index "thermostat_histories", ["low_temperature"], name: "index_thermostat_histories_on_low_temperature", using: :btree
  add_index "thermostat_histories", ["mean_temperature"], name: "index_thermostat_histories_on_mean_temperature", using: :btree
  add_index "thermostat_histories", ["runtime"], name: "index_thermostat_histories_on_runtime", using: :btree
  add_index "thermostat_histories", ["thermostat_id"], name: "index_thermostat_histories_on_thermostat_id", using: :btree
  add_index "thermostat_histories", ["year", "day_of_year"], name: "index_thermostat_histories_on_year_and_day_of_year", using: :btree

  create_table "thermostats", force: true do |t|
    t.string   "name"
    t.float    "current_temperature"
    t.float    "target_temperature"
    t.integer  "mode"
    t.boolean  "running"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "hysteresis"
  end

end
