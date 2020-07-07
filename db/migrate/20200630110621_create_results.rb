class CreateResults < ActiveRecord::Migration[5.2]
  def change
    create_table :results do |t|
      t.integer :raffle_id
      t.integer :customer_id
      t.string :type

      t.timestamps
    end
  end
end
