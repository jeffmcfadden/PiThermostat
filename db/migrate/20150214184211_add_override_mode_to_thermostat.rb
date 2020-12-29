class AddOverrideModeToThermostat < ActiveRecord::Migration[4.2]
  def change
    add_column :thermostats, :override_mode, :integer
  end
end
