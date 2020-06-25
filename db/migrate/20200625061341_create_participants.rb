class CreateParticipants < ActiveRecord::Migration[5.2]
  def change
    create_table :participants do |t|
      t.integer :raffle_id
      t.integer :customer_id

      t.timestamps
    end
  end
end
