class CreateFichas < ActiveRecord::Migration[5.0]
  def change
    create_table :fichas do |t|
      t.text :program
      t.text :general_objective
      t.text :specific_objective
      t.text :didactic_procedures
      t.text :evaluation
      t.text :basic_bibliography
      t.text :bicliography
      t.references :teacher, foreign_key: true
      t.references :matter, foreign_key: true

      t.timestamps
    end
  end
end
