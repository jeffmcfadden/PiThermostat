class ThermostatSchedulesController < ApplicationController
  respond_to :html, :json

  http_basic_authenticate_with name: ENV['BASIC_AUTH_USERNAME'], password: ENV['BASIC_AUTH_PASSWORD'], except: []

  before_filter :load_thermostat, :load_thermostat_schedule

  def index
    @thermostat_schedules = ThermostatSchedule.all

    respond_with @thermostat_schedules
  end

  def show
    respond_with @thermostat_schedule
  end

  def edit
    respond_with @thermostat_schedule
  end

  def new
    @thermostat_schedule = @thermostat.thermostat_schedules.new

    respond_with @thermostat_schedule
  end

  def create
    @thermostat_schedule = @thermostat.thermostat_schedules.create( thermostat_schedule_params )

    respond_with [@thermostat, @thermostat_schedule]
  end

  def update
    @thermostat_schedule = @thermostat_schedule.update_attributes( thermostat_schedule_params )

    respond_with [@thermostat, @thermostat_schedule]
  end


  private

  def thermostat_schedule_params
    params.require( :thermostat_schedule ).permit( :thermostat_id, :name, :active )
  end

  def load_thermostat
    @thermostat = Thermostat.find( params[:thermostat_id] )
  end

  def load_thermostat_schedule
    @thermostat_schedule = ThermostatSchedule.find( params[:id] ) if params[:id].present?
  end

end
