class DestroyTime < ActiveRecord::Migration[5.2]
  def change
    remove_column :brochures, :start_date
    remove_column :days, :start_time

  end
end
