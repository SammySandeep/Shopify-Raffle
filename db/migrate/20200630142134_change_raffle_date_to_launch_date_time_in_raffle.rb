class ChangeRaffleDateToLaunchDateTimeInRaffle < ActiveRecord::Migration[5.2]
  def change
    rename_column :raffles, :raffle_date, :launch_date_time
  end
end
