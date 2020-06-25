class AddInventryToRaffle < ActiveRecord::Migration[5.2]
  def change
    add_column :raffles, :inventry, :integer
  end
end
