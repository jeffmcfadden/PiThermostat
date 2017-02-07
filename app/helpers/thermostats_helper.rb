module ThermostatsHelper
  def temperature_sensor_ids_from_system
    files = Dir.glob("/sys/bus/w1/devices/*")
    devices = if files.present?
      Dir.glob("/sys/bus/w1/devices/*").map do |device|
        File.basename(device)
      end
    else
      ["--No One-Wire devices detected--"]
    end
    devices << Thermostat.thermostat.temperature_sensor_id if Thermostat.thermostat.temperature_sensor_id
    devices.uniq
  end
end
