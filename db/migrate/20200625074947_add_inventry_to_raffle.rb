class AddInventryToRaffle < ActiveRecord::Migration[5.2]
  def change
    add_column :raffles, :inventory, :integer, default: 0
  end
end
