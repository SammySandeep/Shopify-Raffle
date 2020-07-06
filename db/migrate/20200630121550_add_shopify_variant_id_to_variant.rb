class AddShopifyVariantIdToVariant < ActiveRecord::Migration[5.2]
  def change
    add_column :variants, :shopify_variant_id, :integer
  end
end
