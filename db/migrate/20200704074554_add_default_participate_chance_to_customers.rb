class AddDefaultParticipateChanceToCustomers < ActiveRecord::Migration[5.2]
  def change
    add_column :customers, :default_participant_chance, :integer, :default => 0
  end
end
