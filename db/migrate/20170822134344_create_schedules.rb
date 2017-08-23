class CreateSchedules < ActiveRecord::Migration[5.0]
  def change
    create_table :schedules do |t|
      t.datetime :begin
      t.datetime :duration
      t.integer :day
      
    end
  end
end
