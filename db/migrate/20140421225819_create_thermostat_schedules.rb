class CreateThermostatSchedules < ActiveRecord::Migration[4.2]
  def change
    create_table :thermostat_schedules do |t|
      t.string :name
      t.references :thermostat, index: true
      t.boolean :active

      t.timestamps
    end
  end
end
