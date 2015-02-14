# Run these first:
# sudo modprobe w1-gpio
# sudo modprobe w1-therm

# Shed: /sys/bus/w1/devices/28-00000202301d

require 'yaml'
YAML.load( open( "/www/thermostat/config/application.yml" ).read ).each{ |k,v| ENV[k] = v }

s=`cat /sys/bus/w1/devices/#{ENV['THERMOSTAT_DEVICE']}/w1_slave`
cRaw = s.split( "\n" )[1].split( "t=" )[1].to_i
@c = cRaw / 1000.0
@f = (@c * (9.0/5.0) ) + 32

cmd = "curl -silent -X PATCH --data \"thermostat[current_temperature]=#{@f}\" http://127.0.0.1/thermostats/1"
system( cmd )
