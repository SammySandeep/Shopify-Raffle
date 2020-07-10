class AddPhoneToAddress < ActiveRecord::Migration[5.2]
  def change
    add_column :addresses, :phone, :integer
  end
end
