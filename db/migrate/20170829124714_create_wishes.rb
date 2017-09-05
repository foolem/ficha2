class CreateWishes < ActiveRecord::Migration[5.0]
  def change
    create_table :wishes do |t|
      t.references :option, foreign_key: true
      t.references :user, foreign_key: true
      t.references :group, foreign_key: true
      t.integer :priority
      t.text :comments

      t.timestamps
    end
  end
end
