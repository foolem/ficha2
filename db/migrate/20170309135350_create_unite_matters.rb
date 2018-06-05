class CreateUniteMatters < ActiveRecord::Migration[5.0]
  def change
    create_table :unite_matters do |t|
      t.string :name
      t.references :semester, foreign_key: true
      t.timestamps
    end
  end
end
