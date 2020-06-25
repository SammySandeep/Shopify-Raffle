class CreateCustomers < ActiveRecord::Migration[5.2]
  def change
    create_table :customers do |t|
      t.bigint :shopify_customer_id
      t.string :first_name
      t.string :last_name
      t.string :email_id
      t.integer :default_participant_chance
      t.integer :shop_id

      t.timestamps
    end
  end
end
