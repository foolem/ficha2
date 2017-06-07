class CreateFichas < ActiveRecord::Migration[5.0]
  def change
    create_table :fichas do |t|
      t.string :general_objective
      t.text :specific_objective, default: ""

      t.text :program, default: ""
      t.text :didactic_procedures, default: ""
      t.text :evaluation, default: ""
      t.text :basic_bibliography, default: ""
      t.text :bibliography, default: ""

      t.string :status, default: "Enviado"
      t.string :team, default: "A"
      t.text :appraisal,default: ""

      t.integer :year, default: 2017
      t.integer :semester, default: 1

      t.references :user, foreign_key: true
      t.references :matter, foreign_key: true

      t.timestamps
    end
  end
end
