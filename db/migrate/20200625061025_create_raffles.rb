class CreateRaffles < ActiveRecord::Migration[5.2]
  def change
    create_table :raffles do |t|
      t.string :title
      t.timestamp :raffle_date
      t.integer :shop_id
      t.integer :winner_customer_id
      t.string :delivery_method

      t.timestamps
    end
  end
end
