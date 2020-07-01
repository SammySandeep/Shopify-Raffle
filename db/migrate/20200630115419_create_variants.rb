class CreateVariants < ActiveRecord::Migration[5.2]
  def change
    create_table :variants do |t|
      t.string :title
      t.integer :inventory_quantity
      t.integer :product_id

      t.timestamps
    end
  end
end
