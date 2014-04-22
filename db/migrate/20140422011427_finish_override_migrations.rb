class FinishOverrideMigrations < ActiveRecord::Migration
  def change
    remove_column :thermostats, :target_temperature
    remove_column :thermostats, :hysteresis
  end
end
