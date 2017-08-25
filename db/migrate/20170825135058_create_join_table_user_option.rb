class CreateJoinTableUserOption < ActiveRecord::Migration[5.0]
  def change
    create_join_table :users, :options do |t|
      t.references :user, foreign_key: true
      t.references :option, foreign_key: true
    end
  end
end
