class ThermostatsController < ApplicationController
  respond_to :html, :json

  before_filter :load_thermostat

  def new
    respond_with @thermostat
  end

  def update
    @thermostat = Thermostat.find( params[:id] )

    if params[:override_value].present?
      params[:thermostat][:override_until] = params[:override_value].to_i.hours.from_now
    end

    @thermostat.update_attributes( thermostat_params )

    respond_with @thermostat
  end

  def im_hot
    @thermostat = Thermostat.find( params[:id] )

    @thermostat.update_attributes( override_until: 15.minutes.from_now, override_target_temperature: @thermostat.target_temperature - 3.0, override_hysteresis: 1.0, override_mode: "override_mode_#{@thermostat.mode}".to_sym  )

    respond_with @thermostat, location: @thermostat
  end

  def im_cold
    @thermostat = Thermostat.find( params[:id] )

    @thermostat.update_attributes( override_until: 15.minutes.from_now, override_target_temperature: @thermostat.target_temperature + 3.0, override_hysteresis: 1.0, override_mode: "override_mode_#{@thermostat.mode}".to_sym  )

    respond_with @thermostat, location: @thermostat
  end

  def log_current_data
    @thermostat = Thermostat.find( params[:id] )

    @history = ThermostatHistory.now_for_thermostat( @thermostat ).first

    if @history.nil?
      @history = ThermostatHistory.create( { thermostat: @thermostat, year: Time.zone.now.year, day_of_year: Time.zone.now.yday } )
    end

    @history.capture_current_data!

    respond_with [@thermostat, @history]
  end

  private

  def thermostat_params
    params.require( :thermostat ).permit( :name, :current_temperature, :target_temperature, :mode, :running, :hysteresis, :override_until, :override_target_temperature, :override_hysteresis, :override_mode )
  end

  def load_thermostat
    @thermostat = Thermostat.find( params[:id] )
  end


end
