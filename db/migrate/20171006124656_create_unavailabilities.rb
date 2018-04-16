class CreateUnavailabilities < ActiveRecord::Migration[5.0]
  def change
    create_table :unavailabilities do |t|
      t.references :availability, foreign_key: true
      t.references :schedule, foreign_key: true

      t.timestamps
    end
  end
end
