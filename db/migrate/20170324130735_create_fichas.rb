class CreateFichas < ActiveRecord::Migration[5.0]
  def change
    create_table :fichas do |t|
      t.text :general_objective
      t.text :specific_objective

      t.text :program
      t.text :didactic_procedures
      t.text :evaluation
      t.text :basic_bibliography
      t.text :bibliography

      t.string :status, default: "Editando"
      t.string :team, default: "A"
      t.text :appraisal

      t.integer :year
      t.integer :semester

      t.references :user, foreign_key: true
      t.references :matter, foreign_key: true

      t.timestamps
    end
  end
end
