class ThermostatSchedulesController < ApplicationController
  # respond_to :html, :json

  before_action :ensure_authentication!, except: []
  before_action :load_thermostat, :load_thermostat_schedule

  def index
    @thermostat_schedules = ThermostatSchedule.order(:name)
    @thermostat_schedule = @thermostat.thermostat_schedules.new
  end

  def show
  end

  def edit
  end

  def new
    @thermostat_schedule = @thermostat.thermostat_schedules.new
  end

  def create
    @thermostat_schedule = @thermostat.thermostat_schedules.create( thermostat_schedule_params )
    redirect_to @thermostat_schedule
  end

  def update
    @thermostat_schedule.update_attributes( thermostat_schedule_params )
    redirect_to @thermostat_schedule
  end

  def destroy
    @thermostat_schedule.destroy
    redirect_to thermostat_schedules_path
  end

  def make_active
    @thermostat_schedule.make_active!
    redirect_to thermostat_schedules_path
  end


  private

  def thermostat_schedule_params
    params.require( :thermostat_schedule ).permit( :name, :stir_air, :stir_air_minutes, :stir_air_window )
  end

  def load_thermostat_schedule
    @thermostat_schedule = ThermostatSchedule.find( params[:id] ) if params[:id].present?
  end

end
