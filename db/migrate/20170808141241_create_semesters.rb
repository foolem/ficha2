class CreateSemesters < ActiveRecord::Migration[5.0]
  def change
    create_table :semesters do |t|
      t.integer :year
      t.integer :semester

      t.timestamps
    end
  end
end
