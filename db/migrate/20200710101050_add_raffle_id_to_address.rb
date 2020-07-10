class AddRaffleIdToAddress < ActiveRecord::Migration[5.2]
  def change
    add_column :addresses, :raffle_id, :integer
  end
end
