# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2017_10_02_191250) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "thermostat_histories", id: :serial, force: :cascade do |t|
    t.integer "thermostat_id"
    t.integer "year"
    t.integer "day_of_year"
    t.float "low_temperature"
    t.float "high_temperature"
    t.float "mean_temperature"
    t.integer "runtime"
    t.text "json_archive"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["high_temperature"], name: "index_thermostat_histories_on_high_temperature"
    t.index ["low_temperature"], name: "index_thermostat_histories_on_low_temperature"
    t.index ["mean_temperature"], name: "index_thermostat_histories_on_mean_temperature"
    t.index ["runtime"], name: "index_thermostat_histories_on_runtime"
    t.index ["thermostat_id"], name: "index_thermostat_histories_on_thermostat_id"
    t.index ["year", "day_of_year"], name: "index_thermostat_histories_on_year_and_day_of_year"
  end

  create_table "thermostat_schedule_rules", id: :serial, force: :cascade do |t|
    t.integer "thermostat_schedule_id"
    t.boolean "sunday", default: false
    t.boolean "monday", default: false
    t.boolean "tuesday", default: false
    t.boolean "wednesday", default: false
    t.boolean "thursday", default: false
    t.boolean "friday", default: false
    t.boolean "saturday", default: false
    t.integer "hour"
    t.integer "minute"
    t.float "target_temperature"
    t.float "hysteresis"
    t.string "mode", default: "off"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["thermostat_schedule_id"], name: "index_thermostat_schedule_rules_on_thermostat_schedule_id"
  end

  create_table "thermostat_schedules", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "thermostat_id", default: 1
    t.boolean "active", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "stir_air", default: false
    t.integer "stir_air_minutes", default: 5
    t.integer "stir_air_window", default: 60
    t.index ["thermostat_id"], name: "index_thermostat_schedules_on_thermostat_id"
  end

  create_table "thermostats", id: :serial, force: :cascade do |t|
    t.string "name"
    t.float "current_temperature"
    t.integer "mode", default: 0
    t.boolean "running", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "override_until"
    t.float "override_target_temperature"
    t.float "override_hysteresis"
    t.integer "override_mode", default: 0
    t.string "temperature_sensor_id"
    t.integer "gpio_cool_pin"
    t.integer "gpio_heat_pin"
    t.integer "gpio_fan_pin"
    t.string "username"
    t.string "password_digest"
    t.datetime "air_last_stirred_at"
    t.integer "filter_runtime", default: 0
  end

end
