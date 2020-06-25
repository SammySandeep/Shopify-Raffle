class ChangeColumnResultToArray < ActiveRecord::Migration[5.2]
  def change
    add_column :raffles, :result, :integer, array: true, default: []
  end
end
