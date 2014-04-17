class Thermostat < ActiveRecord::Base
  enum mode: [ :off, :fan, :heat, :cool ]

  after_save :perform_thermostat_logic!

  def perform_thermostat_logic!

    if cool?

      if self.current_temperature >= self.target_temperature + self.hysteresis
        _turn_cool_on
      elsif self.current_temperature <= self.target_temperature - self.hysteresis
        _turn_cool_off
      else
        # Do nothing, we're in the null zone.

      end


    elsif off?
      # Turn it all off
    elsif heat?
      # Do nothing right now
    elsif fan?
      # Do nothign right now
    end

  end

  private

  def _turn_cool_on
    if Rails.env == 'production'
      system "gpio write 0 0"
    else
      puts "We're in development or we would be doing: gpio write 0 0"
    end

  end

  def _turn_cool_off
    if Rails.env == 'production'
      system "gpio write 0 1"
    else
      puts "We're in development or we would be doing: gpio write 0 1"
    end
  end

end
