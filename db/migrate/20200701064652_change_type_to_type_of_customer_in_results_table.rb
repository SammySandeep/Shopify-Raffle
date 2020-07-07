class ChangeTypeToTypeOfCustomerInResultsTable < ActiveRecord::Migration[5.2]
  def change
    rename_column :results, :type, :type_of_customer
  end
end
