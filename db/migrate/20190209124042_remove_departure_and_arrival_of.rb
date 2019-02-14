class RemoveDepartureAndArrivalOf < ActiveRecord::Migration[5.2]
  def change
    remove_column :brochures, :departure
    remove_column :brochures, :arrival

  end
end
