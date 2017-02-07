Rails.application.routes.draw do

  resource :thermostat, only: [:new, :create, :edit, :update] do
    member do
      post :migrate_settings
    end
  end

  post '/im_hot'  => "thermostats#im_hot",  as: :im_hot
  post '/im_cold' => "thermostats#im_cold", as: :im_cold
  post '/log_current_data' => "thermostats#log_current_data", as: :log_current_data
  post '/update_current_temperature' => "thermostats#update_current_temperature", as: :update_current_temperature

  resources :thermostat_histories

  resources :thermostat_schedules do
    member do
      post :make_active
    end
    resources :thermostat_schedule_rules
  end

  get 'thermostat' => 'thermostats#show', format: :json
  root 'thermostats#show'
end