class AddVariantIdToRaffle < ActiveRecord::Migration[5.2]
  def change
    add_column :raffles, :variant_id, :integer
  end
end
