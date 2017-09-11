class CreateMatters < ActiveRecord::Migration[5.0]
  def change
    create_table :matters do |t|
      t.string :name
      t.boolean :actived, default: true, null: false
      t.references :unite_matter, foreign_key: true, optional: true

      t.timestamps
    end
  end
end
