class RemoveShopifyProductIdFromRaffle < ActiveRecord::Migration[5.2]
  def change
    remove_column :raffles, :shopify_product_id, :integer
  end
end
