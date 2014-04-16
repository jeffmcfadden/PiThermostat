class HomeController < ApplicationController
  def index
    
    @thermostats = Thermostat.all
    
    # s=`cat /sys/bus/w1/devices/28-00000202301d/w1_slave`
    # cRaw = s.split( "\n" )[1].split( "t=" )[1].to_i
    # @c = cRaw / 1000.0
    # @f = (@c * (9.0/5.0) ) + 32
  end
end
