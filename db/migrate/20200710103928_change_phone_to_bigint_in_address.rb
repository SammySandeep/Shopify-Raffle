class ChangePhoneToBigintInAddress < ActiveRecord::Migration[5.2]
  def change
    change_column :addresses, :phone, :bigint
  end
end
