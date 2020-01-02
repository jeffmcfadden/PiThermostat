class ThermostatScheduleRulesController < ApplicationController

  before_action :load_thermostat, :load_thermostat_schedule, :load_thermostat_schedule_rule
  before_action :ensure_authentication!, except: []  

  def new
    @thermostat_schedule_rule = @thermostat_schedule.thermostat_schedule_rules.new
  end

  def edit
  end

  def update
    @thermostat_schedule_rule.update_attributes( thermostat_schedule_rules_params )
    redirect_to @thermostat_schedule
  end

  def create
    @thermostat_schedule_rule = @thermostat_schedule.thermostat_schedule_rules.create( thermostat_schedule_rules_params )
    redirect_to @thermostat_schedule
  end

  def destroy
    @thermostat_schedule_rule.destroy
    redirect_to @thermostat_schedule
  end

  private

  def thermostat_schedule_rules_params
    params.require( :thermostat_schedule_rule ).permit( :thermostat_schedule_id, :sunday, :monday, :tuesday, :wednesday, :thursday, :friday, :saturday, :sunday, :target_temperature, :hour, :minute, :hysteresis, :mode )
  end

  def load_thermostat_schedule
    @thermostat_schedule = ThermostatSchedule.find( params[:thermostat_schedule_id] )
  end

  def load_thermostat_schedule_rule
    @thermostat_schedule_rule = ThermostatScheduleRule.find( params[:id] ) if params[:id].present?
  end


end
