class AddAirStirringToSchedule < ActiveRecord::Migration[5.0]
  def change

    add_column :thermostat_schedules, :stir_air, :boolean, default: false
    add_column :thermostat_schedules, :stir_air_minutes, :integer, default: 5
    add_column :thermostat_schedules, :stir_air_window,  :integer, default: 60
    add_column :thermostats, :air_last_stirred_at,  :datetime

  end
end
