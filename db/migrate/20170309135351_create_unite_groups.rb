class CreateUniteGroups < ActiveRecord::Migration[5.0]
  def change
    create_table :unite_groups do |t|
      t.string :name
      t.references :unite_matter, foreign_key: true, optional: true

      t.timestamps
    end
  end
end
