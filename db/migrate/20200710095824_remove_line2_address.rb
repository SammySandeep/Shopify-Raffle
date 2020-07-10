class RemoveLine2Address < ActiveRecord::Migration[5.2]
  def change
    remove_column :addresses, :line2
  end
end
