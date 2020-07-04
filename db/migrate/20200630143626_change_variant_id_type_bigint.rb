class ChangeVariantIdTypeBigint < ActiveRecord::Migration[5.2]
  def change
    change_column :variants, :shopify_variant_id, :bigint
  end
end
