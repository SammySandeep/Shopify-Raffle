class CreateVerifications < ActiveRecord::Migration[5.2]
  def change
    create_table :verifications do |t|
      t.string :code
      t.integer :customer_id

      t.timestamps
    end
  end
end
