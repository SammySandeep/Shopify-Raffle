class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string :shopify_product_title
      t.bigint :shopify_product_id
      t.boolean :has_variant
      t.integer :shop_id

      t.timestamps
    end
  end
end
