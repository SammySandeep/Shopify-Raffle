class RemoveDefaultParticipantChanceFromCustomer < ActiveRecord::Migration[5.2]
  def change
    remove_column :customers, :default_participant_chance, :integer
  end
end
