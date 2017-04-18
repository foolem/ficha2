class CreateFichas < ActiveRecord::Migration[5.0]
  def change
    create_table :fichas do |t|
      t.text :program
      t.string :general_objective

      t.text :specific_objective
      t.text :didactic_procedures
      t.text :evaluation
      t.text :basic_bibliography
      t.text :bicliography

      t.string :status, default: "Enviado"
      t.text :appraisal

      t.references :user, foreign_key: true
      t.references :matter, foreign_key: true

      t.timestamps
    end
  end
end
