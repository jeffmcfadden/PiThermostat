class AddOverrideModeToThermostat < ActiveRecord::Migration
  def change
    add_column :thermostats, :override_mode, :integer
  end
end
