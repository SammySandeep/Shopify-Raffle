class AddStatusToRaffle < ActiveRecord::Migration[5.2]
  def change
    add_column :raffles, :status, :string
  end
end
