class SetDefaults < ActiveRecord::Migration
  def change
    change_column :thermostat_schedule_rules, :sunday,    :boolean, default: false
    change_column :thermostat_schedule_rules, :monday,    :boolean, default: false
    change_column :thermostat_schedule_rules, :tuesday,   :boolean, default: false
    change_column :thermostat_schedule_rules, :wednesday, :boolean, default: false
    change_column :thermostat_schedule_rules, :thursday,  :boolean, default: false
    change_column :thermostat_schedule_rules, :friday,    :boolean, default: false
    change_column :thermostat_schedule_rules, :saturday,  :boolean, default: false
    change_column :thermostat_schedule_rules, :mode,      :string,  default: "off"

    change_column :thermostat_schedules, :thermostat_id, :integer, default: 1
    change_column :thermostat_schedules, :active,        :boolean, default: false

    change_column :thermostats, :mode,          :integer, default: 0
    change_column :thermostats, :running,       :boolean, default: false
    change_column :thermostats, :override_mode, :integer, default: 0
  end
end
