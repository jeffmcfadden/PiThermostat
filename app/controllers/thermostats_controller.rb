class ThermostatsController < ApplicationController
  respond_to :html, :json

  def update
    @thermostat = Thermostat.find( params[:id] )

    @thermostat.update_attributes( thermostat_params )

    respond_with @thermostat
  end

  private

  def thermostat_params
    params.require( :thermostat ).permit( :name, :current_temperature, :target_temperature, :mode, :running, :hysteresis )
  end

end
