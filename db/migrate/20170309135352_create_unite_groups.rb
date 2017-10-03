class CreateUniteGroups < ActiveRecord::Migration[5.0]
  def change
    create_table :unite_groups do |t|
      t.references :matter, foreign_key: true
      t.references :semester, foreign_key: true
      t.timestamps
    end
  end
end
