class CreateMatters < ActiveRecord::Migration[5.0]
  def change
    create_table :matters do |t|

      t.references :unite_matter, foreign_key: true, optional: true

      t.boolean :actived, default: true, null: false
      t.string :name
      t.string :code
      t.string :kind
      t.string :prerequisite, default: "Nenhum"
      t.string :corequisite, default: "Nenhum"
      t.string :modality
      t.string :nature
      t.text :menu

      t.text :basic_bibliography
      t.text :bibliography

      t.integer :annual_workload, default: 0
      t.integer :semester_workload, default: 0
      t.integer :modular_workload, default: 0
      t.integer :weekly_workload, default: 0

      t.integer :pd, default: 0
      t.integer :lc, default: 0
      t.integer :cp, default: 0
      t.integer :es, default: 0
      t.integer :or, default: 0

      t.timestamps
    end
  end
end
