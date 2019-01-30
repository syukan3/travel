class AddDatetime < ActiveRecord::Migration[5.2]
  def change
    add_column :brochures, :start_date, :datetime
    add_column :days, :start_time, :datetime

  end
end
