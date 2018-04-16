class CreateSchedules < ActiveRecord::Migration[5.0]
  def change
    create_table :schedules do |t|
      t.time :begin
      t.time :duration
      t.integer :day

    end
  end
end
