class DestroySpotStartTime < ActiveRecord::Migration[5.2]
  def change
    remove_column :spots, :start_time

  end
end
