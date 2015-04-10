class ThermostatScheduleRulesController < ApplicationController

  before_filter :load_thermostat, :load_thermostat_schedule, :load_thermostat_schedule_rule

  http_basic_authenticate_with name: ENV['BASIC_AUTH_USERNAME'], password: ENV['BASIC_AUTH_PASSWORD'], except: []

  def new
    @thermostat_schedule_rule = @thermostat_schedule.thermostat_schedule_rules.new

    respond_with [@thermostat, @thermostat_schedule, @thermostat_schedule_rule]
  end

  def edit
    respond_with [@thermostat, @thermostat_schedule, @thermostat_schedule_rule]
  end

  def update
    @thermostat_schedule_rule.update_attributes( thermostat_schedule_rules_params )

    respond_with [@thermostat, @thermostat_schedule]
  end

  def create
    @thermostat_schedule_rule = @thermostat_schedule.thermostat_schedule_rules.create( thermostat_schedule_rules_params )

    respond_with [@thermostat, @thermostat_schedule]
  end

  private

  def thermostat_schedule_rules_params
    params.require( :thermostat_schedule_rule ).permit( :thermostat_schedule_id, :sunday, :monday, :tuesday, :wednesday, :thursday, :friday, :saturday, :sunday, :target_temperature, :hour, :minute, :hysteresis, :mode )
  end

  def load_thermostat
    @thermostat = Thermostat.find( params[:thermostat_id] )
  end

  def load_thermostat_schedule
    @thermostat_schedule = ThermostatSchedule.find( params[:thermostat_schedule_id] )
  end

  def load_thermostat_schedule_rule
    @thermostat_schedule_rule = ThermostatScheduleRule.find( params[:id] ) if params[:id].present?
  end


end
