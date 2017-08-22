class CreateFichas < ActiveRecord::Migration[5.0]
  def change
    create_table :fichas do |t|

      t.integer :status, default: 0

      t.text :program
      t.text :didactic_procedures
      t.text :evaluation
      t.text :general_objective
      t.text :specific_objective
      t.text :basic_bibliography
      t.text :bibliography

      t.text :appraisal

      t.references :user, foreign_key: true
      t.references :group, foreign_key: true

      t.timestamps
    end
  end
end
