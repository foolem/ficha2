class CreateSemesters < ActiveRecord::Migration[5.0]
  def change
    create_table :semesters do |t|
      t.integer :year
      t.integer :semester
      
      t.boolean :options_selection, default: false, null: false
      t.boolean :options_generated, default: false, null: false
      t.boolean :options_finished, default: false, null: false

      t.timestamps
    end
  end
end
