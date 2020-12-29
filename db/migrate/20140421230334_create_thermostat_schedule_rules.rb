class CreateThermostatScheduleRules < ActiveRecord::Migration[4.2]
  def change
    create_table :thermostat_schedule_rules do |t|
      t.references :thermostat_schedule, index: true
      t.boolean :sunday
      t.boolean :monday
      t.boolean :tuesday
      t.boolean :wednesday
      t.boolean :thursday
      t.boolean :friday
      t.boolean :saturday
      t.integer :hour
      t.integer :minute
      t.float :target_temperature
      t.float :hysteresis
      t.string :mode

      t.timestamps
    end
  end
end
