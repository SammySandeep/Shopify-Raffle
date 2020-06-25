class AddShopifyProductIdToRaffle < ActiveRecord::Migration[5.2]
  def change
    add_column :raffles, :shopify_product_id, :bigint
  end
end
