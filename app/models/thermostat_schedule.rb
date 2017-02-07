class ThermostatSchedule < ApplicationRecord
  belongs_to :thermostat
  has_many :thermostat_schedule_rules, dependent: :destroy

  scope :active, -> { where( active: true ) }

  after_save :make_active_if_no_other_schedules_active

  def make_active!
    thermostat.thermostat_schedules.update_all(active: false)
    update_attributes(active: true)
  end

  def make_active_if_no_other_schedules_active
    return if self.class.active.exists?
    make_active!
  end
end
