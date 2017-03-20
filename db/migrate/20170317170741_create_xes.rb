class CreateXes < ActiveRecord::Migration[5.0]
  def change
    create_table :xes do |t|
      t.string :name

      t.timestamps
    end
  end
end
