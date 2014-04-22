class ThermostatHistory < ActiveRecord::Base
  belongs_to :thermostat

  scope :now_for_thermostat,  -> (thermostat) {
    year = Time.now.year
    yday = Time.now.yday

    where( ["thermostat_id = ? AND year = ? AND day_of_year = ?", thermostat.id, year, yday] )
  }

  scope :today, -> {
    year = Time.now.year
    yday = Time.now.yday

    where( ["year = ? AND day_of_year = ?", year, yday] )
  }

  def capture_current_data!
    existing_data = JSON.parse( self.json_archive, symbolize_names: true ) rescue []

    this_record = { ts: Time.now.to_i,
                    tt: self.thermostat.target_temperature,
                    ct: self.thermostat.current_temperature,
                    r: (self.thermostat.running? ? 1 : 0 ),
                    m: self.thermostat.mode }

    existing_data.push( this_record )

    self.high_temperature = existing_data.max_by { |h| h[:ct] }[:ct]
    self.low_temperature  = existing_data.min_by { |h| h[:ct] }[:ct]
    self.mean_temperature = existing_data.collect{ |h| h[:ct] }.sum.to_f / existing_data.size.to_f
    self.runtime          = existing_data.collect{ |h| h[:r ] }.sum

    self.json_archive = existing_data.to_json

    save
  end

  def json_for_flot
    existing_data = JSON.parse( self.json_archive, symbolize_names: true ) rescue []

    for_flot = []
    existing_data.each do |record|
      for_flot.push( [ ( record[:ts] * 1000 ), record[:ct] ] ) #*1000 for js ms
    end

    for_flot.to_json
  end

end
