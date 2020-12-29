class CreateThermostatHistories < ActiveRecord::Migration[4.2]
  def change
    create_table :thermostat_histories do |t|
      t.integer :thermostat_id
      t.integer :year
      t.integer :day_of_year
      t.float :low_temperature
      t.float :high_temperature
      t.float :mean_temperature
      t.integer :runtime
      t.text :json_archive

      t.timestamps
    end
    add_index :thermostat_histories, :thermostat_id
    add_index :thermostat_histories, [:year, :day_of_year]
    add_index :thermostat_histories, :low_temperature
    add_index :thermostat_histories, :high_temperature
    add_index :thermostat_histories, :mean_temperature
    add_index :thermostat_histories, :runtime
  end
end
