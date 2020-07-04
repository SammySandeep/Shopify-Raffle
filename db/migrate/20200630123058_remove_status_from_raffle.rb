class RemoveStatusFromRaffle < ActiveRecord::Migration[5.2]
  def change
    remove_column :raffles, :status, :string
  end
end
