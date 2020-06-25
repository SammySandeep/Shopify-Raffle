class CreateAddresses < ActiveRecord::Migration[5.2]
  def change
    create_table :addresses do |t|
      t.string :line1
      t.string :line2
      t.string :city
      t.string :country
      t.string :state
      t.integer :pin
      t.integer :customer_id

      t.timestamps
    end
  end
end
