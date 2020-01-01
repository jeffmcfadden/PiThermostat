class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  def ensure_authentication
    if Thermostat&.thermostat&.username.present?
      authenticate_or_request_with_http_basic('Thermostat') do |username, password|
        Thermostat.thermostat.username == username && Thermostat.thermostat.authenticate(password)
      end
    end
  end

  def load_thermostat
    @thermostat = Thermostat.thermostat
  end

end