class FinishOverrideMigrations < ActiveRecord::Migration[4.2]
  def change
    remove_column :thermostats, :target_temperature
    remove_column :thermostats, :hysteresis
  end
end
