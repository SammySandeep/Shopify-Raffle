class RenameLine1ToAddressInAddresses < ActiveRecord::Migration[5.2]
  def change
    rename_column :addresses, :line1, :address
  end
end
