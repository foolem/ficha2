class CreateAvailabilities < ActiveRecord::Migration[5.0]
  def change
    create_table :availabilities do |t|
      t.references :semester, foreign_key: true
      t.references :user, foreign_key: true

      t.integer :preference_first
      t.integer :preference_second
      t.integer :preference_third

      t.string :comments

      t.timestamps
    end
  end
end
