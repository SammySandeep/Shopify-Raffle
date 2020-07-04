class RemoveResultFromRaffle < ActiveRecord::Migration[5.2]
  def change
    remove_column :raffles, :result, :string
  end
end
