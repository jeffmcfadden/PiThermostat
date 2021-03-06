class ThermostatsController < ApplicationController
  # respond_to :html, :json

  before_action :load_thermostat, except: [:new, :create]
  before_action :ensure_authentication!, except: [:new, :create, :show, :update_current_temperature, :log_current_data]

  def new
    @thermostat = Thermostat.new
  end

  def create
    @thermostat = Thermostat.create(thermostat_params) unless Thermostat.thermostat.present?
    redirect_to root_path
  end

  def edit
  end

  def update
    if params[:override_value].present?
      params[:thermostat][:override_until] = params[:override_value].to_f.hours.from_now
    end

    @thermostat.update( thermostat_params )

    if params[:thermostat][:password].present? && params[:thermostat][:username].present?
      @thermostat.update(username: params[:thermostat][:username], password: params[:thermostat][:password])
    end

    redirect_to root_path
  end

  def show
    redirect_to new_thermostat_path and return unless @thermostat
    redirect_to new_user_path and return unless User.count > 0
    ensure_authentication!

    # Sheesh how slow is this going to be:
    @thermostat_for_json = JSON.parse( @thermostat.to_json )

    @thermostat_for_json[:target_temperature] = @thermostat.target_temperature
    @thermostat_for_json[:hysteresis]         = @thermostat.hysteresis
    @thermostat_for_json[:on_override]        = @thermostat.on_override?

    respond_to do |format|
      format.html
      format.json { render :json => @thermostat_for_json }
    end
  end

  def im_hot
    @thermostat.update( override_until: 15.minutes.from_now, override_target_temperature: @thermostat.target_temperature - 3.0, override_hysteresis: 1.0, override_mode: "override_mode_#{@thermostat.mode}".to_sym  )

    # Sheesh how slow is this going to be:
    @thermostat_for_json = JSON.parse( @thermostat.to_json )

    @thermostat_for_json[:target_temperature] = @thermostat.target_temperature
    @thermostat_for_json[:hysteresis]         = @thermostat.hysteresis
    @thermostat_for_json[:on_override]        = @thermostat.on_override?

    respond_to do |format|
      format.html { redirect_to root_path }
      format.json { render :json => @thermostat_for_json }
    end
  end

  def im_cold
    @thermostat.update( override_until: 15.minutes.from_now, override_target_temperature: @thermostat.target_temperature + 3.0, override_hysteresis: 1.0, override_mode: "override_mode_#{@thermostat.mode}".to_sym  )

    # Sheesh how slow is this going to be:
    @thermostat_for_json = JSON.parse( @thermostat.to_json )

    @thermostat_for_json[:target_temperature] = @thermostat.target_temperature
    @thermostat_for_json[:hysteresis]         = @thermostat.hysteresis
    @thermostat_for_json[:on_override]        = @thermostat.on_override?

    respond_to do |format|
      format.html { redirect_to root_path }
      format.json { render :json => @thermostat_for_json }
    end
  end
  
  def reset_filter_runtime
    @thermostat.update( filter_runtime: 0 )
    redirect_to root_path
  end

  def log_current_data
    @history = ThermostatHistory.now_for_thermostat( @thermostat ).first

    if @history.nil?
      @history = ThermostatHistory.create( { thermostat: @thermostat, year: Time.zone.now.year, day_of_year: Time.zone.now.yday } )
    end

    head :ok if @history.capture_current_data!
  end

  def update_current_temperature
    head :ok if @thermostat.update_current_temperature!
  end

  def migrate_settings
    @thermostat.temperature_sensor_id = ENV['THERMOSTAT_DEVICE'] if ENV['THERMOSTAT_DEVICE']
    @thermostat.gpio_cool_pin         = ENV['HVAC_COOL_PIN']     if ENV['HVAC_COOL_PIN']
    @thermostat.gpio_heat_pin         = ENV['HVAC_HEAT_PIN']     if ENV['HVAC_HEAT_PIN']
    @thermostat.gpio_fan_pin          = ENV['HVAC_FAN_PIN']      if ENV['HVAC_FAN_PIN']
    if ENV['BASIC_AUTH_USERNAME'] && ENV['BASIC_AUTH_PASSWORD']
      @thermostat.username = ENV['BASIC_AUTH_USERNAME']
      @thermostat.password = ENV['BASIC_AUTH_PASSWORD']
    end
    @thermostat.save

    redirect_to root_path
  end

  private

  def thermostat_params
    params.require( :thermostat ).permit(
      :name,
      :current_temperature,
      :target_temperature,
      :mode,
      :running,
      :hysteresis,
      :override_until,
      :override_target_temperature,
      :override_hysteresis,
      :override_mode,
      :temperature_sensor_id,
      :gpio_cool_pin,
      :gpio_heat_pin,
      :gpio_fan_pin,
      :username,
      :password
    )
  end
end
