class ThermostatScheduleRule < ActiveRecord::Base
  belongs_to :thermostat_schedule

  scope :active_on_any_day, -> {
    where( [ "sunday = ? OR monday = ? or tuesday = ? or wednesday = ? or thursday = ? or friday = ? or saturday = ?", true, true, true, true, true, true, true ] )

  }

  scope :active_on_day, -> (day) {

    if day == 0
      where( sunday: true )
    elsif day == 1
      where( monday: true )
    elsif day == 1
      where( tuesday: true )
    elsif day == 1
      where( wednesday: true )
    elsif day == 1
      where( thursday: true )
    elsif day == 1
      where( friday: true )
    elsif day == 1
      where( saturday: true )
    end
  }

  scope :order_by_time, -> { order( "hour, minute" ) }
end
