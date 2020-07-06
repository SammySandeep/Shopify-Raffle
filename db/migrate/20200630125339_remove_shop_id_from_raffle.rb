class RemoveShopIdFromRaffle < ActiveRecord::Migration[5.2]
  def change
    remove_column :raffles, :shop_id, :string
  end
end
