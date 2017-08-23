class CreateJoinTableGroupSchedule < ActiveRecord::Migration[5.0]
  def change
    create_join_table :groups, :schedules do |t|
      t.references :schedule, foreign_key: true
      t.references :group, foreign_key: true
    end
  end
end
