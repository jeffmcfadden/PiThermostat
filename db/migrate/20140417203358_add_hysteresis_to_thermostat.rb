class AddHysteresisToThermostat < ActiveRecord::Migration
  def change
    add_column :thermostats, :hysteresis, :float
  end
end
