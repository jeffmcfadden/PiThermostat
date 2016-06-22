# You have to do this before you an get things to work:
# $ gpio mode 0 out

class Thermostat < ActiveRecord::Base
  enum mode: [ :off, :fan, :heat, :cool ]
  enum override_mode: [ :override_mode_off, :override_mode_fan, :override_mode_heat, :override_mode_cool ]

  has_many :thermostat_histories
  has_many :thermostat_schedules

  after_save :perform_thermostat_logic!
  
  validates_inclusion_of :id, in: [1] # Only allow one Thermostat
  
  def self.new(attrs = {})
    # Always set the ID to 1
    super(attrs.merge(id: 1))
  end

  def target_temperature
    if self.on_override?
      tt = self.override_target_temperature
    else
      tt = active_schedule_rule.target_temperature
    end

    tt
  end

  def hysteresis
    if self.on_override?
      h = self.override_hysteresis
    else
      h = active_schedule_rule.hysteresis
    end

    h
  end

  def active_schedule
    self.thermostat_schedules.active.first
  end

  def active_schedule_rule( wday = nil, last = false )
    wday = Time.zone.now.wday if wday.nil?

    schedule = self.active_schedule

    # Iterate through the schedule rules.
    # The idea is that if you get to a point where you've passed the trigger time
    # for that rule, then it's active.
    # The last case is where you never hit a rule, which means you're before *all* rules
    # and therefore you should really be on the last rule from the previous day.
    if schedule.present? && (schedule.thermostat_schedule_rules.active_on_any_day.count > 0)
      active_rule = nil
      rules = schedule.thermostat_schedule_rules.active_on_day( wday ).order_by_time

      if last
        active_rule = rules.last
      else
        rules.each do |rule|
          if ( ( rule.hour * 60 ) + rule.minute ) < ( ( Time.zone.now.hour * 60 ) + Time.zone.now.min )
            active_rule = rule
          end
        end
      end

      # Go find the last active rule from the previous day.
      if active_rule.nil?
        wday -= 1
        wday = 6 if wday < 0
        active_rule = active_schedule_rule( wday, true )
      end

      return active_rule
    end

    # Fallback rule if no active schedule.
    ThermostatScheduleRule.new( target_temperature: 80, mode: :cool, hysteresis: 0.5 )
  end

  def perform_thermostat_logic!

    # First, make sure the mode is set correctly in case we just switched modes.
    if on_override?
      if self.mode.to_s != self.override_mode.to_s.gsub( 'override_mode_', '' )
        mode_value = Thermostat.modes[self.override_mode.to_s.gsub( 'override_mode_', '' ).to_sym]
        self.update_column( :mode, mode_value )

        _turn_all_off # Turn everything off since we'll be toggling modes here.
      end
    else
      if self.active_schedule_rule.mode != self.mode
        mode_value = Thermostat.modes[self.active_schedule_rule.mode]
        self.update_column( :mode, mode_value )

        _turn_all_off # Turn everything off since we'll be toggling modes here.
      end
    end

    if cool?
      if self.current_temperature >= self.target_temperature + self.hysteresis
        _turn_cool_on
      elsif self.current_temperature <= self.target_temperature - self.hysteresis
        _turn_cool_off
      else
        # Do nothing, we're in the null zone.
      end
    elsif off?
      _turn_cool_off
      _turn_heat_off
    elsif heat?
      if self.current_temperature <= self.target_temperature - self.hysteresis
        _turn_heat_on
      elsif self.current_temperature >= self.target_temperature + self.hysteresis
        _turn_heat_off
      else
        # Do nothing, we're in the null zone.
      end
    elsif fan?
      _turn_cool_off
      _turn_heat_off
      _turn_fan_on
    end

  end

  def on_override?
    self.override_until.present? && self.override_until > Time.now
  end

  private

  def _turn_all_off
    _turn_cool_off
    _turn_heat_off
    _turn_fan_off
  end

  def _turn_cool_on
    if Rails.env == 'production'
      system "gpio write #{ENV['HVAC_COOL_PIN']} 0"
    else
      puts "We're in development or we would be doing: gpio write #{ENV['HVAC_COOL_PIN']} 0"
    end

    self.update_column( :running, true )
  end

  def _turn_cool_off
    if Rails.env == 'production'
      system "gpio write #{ENV['HVAC_COOL_PIN']} 1"
    else
      puts "We're in development or we would be doing: gpio write #{ENV['HVAC_COOL_PIN']} 1"
    end

    self.update_column( :running, false )
  end

  def _turn_heat_on
    if Rails.env == 'production'
      system "gpio write #{ENV['HVAC_HEAT_PIN']} 0"
    else
      puts "We're in development or we would be doing: gpio write #{ENV['HVAC_HEAT_PIN']} 0"
    end

    self.update_column( :running, true )
  end

  def _turn_heat_off
    if Rails.env == 'production'
      system "gpio write #{ENV['HVAC_HEAT_PIN']} 1"
    else
      puts "We're in development or we would be doing: gpio write #{ENV['HVAC_HEAT_PIN']} 1"
    end

    self.update_column( :running, false )
  end

  def _turn_fan_on
    if Rails.env == 'production'
      system "gpio write #{ENV['HVAC_FAN_PIN']} 0"
    else
      puts "We're in development or we would be doing: gpio write #{ENV['HVAC_FAN_PIN']} 0"
    end

    self.update_column( :running, false )
  end

  def _turn_fan_off
    if Rails.env == 'production'
      system "gpio write #{ENV['HVAC_FAN_PIN']} 1"
    else
      puts "We're in development or we would be doing: gpio write 1 1"
    end

    self.update_column( :running, false )
  end

end
