class CreateOptions < ActiveRecord::Migration[5.0]
  def change
    create_table :options do |t|
      t.references :semester, foreign_key: true
      t.timestamps
    end
  end
end
