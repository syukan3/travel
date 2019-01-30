class AddStartDate < ActiveRecord::Migration[5.2]
  def change
    add_column :brochures, :start_date, :time
  end
end
