class AddThermostatSettings < ActiveRecord::Migration
  def change
    add_column :thermostats, :temperature_sensor_id, :string,  default: nil
    add_column :thermostats, :gpio_cool_pin,         :integer, default: nil
    add_column :thermostats, :gpio_heat_pin,         :integer, default: nil
    add_column :thermostats, :gpio_fan_pin,          :integer, default: nil
    add_column :thermostats, :username,              :string,  default: nil
    add_column :thermostats, :password_digest,       :string,  default: nil
  end
end
