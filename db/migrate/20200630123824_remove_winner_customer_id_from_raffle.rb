class RemoveWinnerCustomerIdFromRaffle < ActiveRecord::Migration[5.2]
  def change
    remove_column :raffles, :winner_customer_id, :string
  end
end
