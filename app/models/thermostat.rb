class Thermostat < ActiveRecord::Base
  enum mode: [ :off, :fan, :heat, :cool ]
end
