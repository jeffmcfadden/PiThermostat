class AddOverridesToThermostat < ActiveRecord::Migration
  def change
    add_column :thermostats, :override_until, :datetime
    add_column :thermostats, :override_target_temperature, :float
    add_column :thermostats, :override_hysteresis, :float
  end
end
