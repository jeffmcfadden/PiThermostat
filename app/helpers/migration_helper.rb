module MigrationHelper
  def needs_migration?
    ENV["THERMOSTAT_DEVICE"].present? && Thermostat.thermostat.temperature_sensor_id.blank?
  end
end