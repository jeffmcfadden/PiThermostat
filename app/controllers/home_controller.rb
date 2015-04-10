class HomeController < ApplicationController
  http_basic_authenticate_with name: ENV['BASIC_AUTH_USERNAME'], password: ENV['BASIC_AUTH_PASSWORD'], except: []

  def index

    @thermostats = Thermostat.all

    # s=`cat /sys/bus/w1/devices/28-00000202301d/w1_slave`
    # cRaw = s.split( "\n" )[1].split( "t=" )[1].to_i
    # @c = cRaw / 1000.0
    # @f = (@c * (9.0/5.0) ) + 32
  end
end
