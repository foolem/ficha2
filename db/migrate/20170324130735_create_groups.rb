class CreateGroups < ActiveRecord::Migration[5.0]
  def change
    create_table :groups do |t|
      t.string :name
      t.references :matter, foreign_key: true
      t.references :semester, foreign_key: true
      t.references :option, foreign_key: true
      t.references :unite_group, foreign_key: true, optional: true
      t.references :course, foreign_key: true
      t.string :vacancies
      t.string :class_room

      t.timestamps
    end
  end
end
