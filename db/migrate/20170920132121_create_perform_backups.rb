class CreatePerformBackups < ActiveRecord::Migration[5.0]
  def change
    create_table :perform_backups do |t|
      t.integer :days
      t.time :time

      t.timestamps
    end
  end
end
