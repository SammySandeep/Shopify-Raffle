class AddNumberOfRunnerToSettings < ActiveRecord::Migration[5.2]
  def change
    add_column :settings, :number_of_runner, :integer
  end
end
