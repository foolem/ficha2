class AddFielsToMatter < ActiveRecord::Migration[5.0]
  def change
    add_column :matters, :code, :string
    add_column :matters, :kind, :string
    add_column :matters, :prerequisite, :string
    add_column :matters, :corequisite, :string
    add_column :matters, :modality, :string
    add_column :matters, :nature, :string
    add_column :matters, :menu, :string,  default: ""

    add_column :matters, :total_annual_workload, :integer
    add_column :matters, :total_weekly_workload, :integer
    add_column :matters, :total_modular_workload, :integer
    add_column :matters, :weekly_workload, :integer

    add_column :matters, :pd, :integer
    add_column :matters, :lc, :integer
    add_column :matters, :cp, :integer
    add_column :matters, :es, :integer
    add_column :matters, :or, :integer

  end

end
