class AddFilterRuntimeToThermostat < ActiveRecord::Migration[5.1]
  def change
    add_column :thermostats, :filter_runtime, :integer, default: 0
  end
end
