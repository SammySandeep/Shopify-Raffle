class CreateNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :notifications do |t|
      t.boolean :notified
      t.integer :result_id

      t.timestamps
    end
  end
end
