class CreateSettings < ActiveRecord::Migration[5.2]
  def change
    create_table :settings do |t|
      t.integer :shop_id
      t.text :email_body_for_winner
      t.text :email_body_for_participant
      t.text :email_body_for_registration
      t.text :email_body_for_customer_registration_verification
      t.integer :purchase_window

      t.timestamps
    end
  end
end
