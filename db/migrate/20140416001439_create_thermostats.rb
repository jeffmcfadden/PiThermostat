class CreateThermostats < ActiveRecord::Migration[4.2]
  def change
    create_table :thermostats do |t|
      t.string :name
      t.float :current_temperature
      t.float :target_temperature
      t.integer :mode
      t.boolean :running

      t.timestamps
    end
  end
end
