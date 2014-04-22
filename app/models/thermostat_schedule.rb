class ThermostatSchedule < ActiveRecord::Base
  belongs_to :thermostat
  has_many :thermostat_schedule_rules

  scope :active, -> { where( active: true ) }
end
