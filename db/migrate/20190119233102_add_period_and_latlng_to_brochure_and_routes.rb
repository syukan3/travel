class AddPeriodAndLatlngToBrochureAndRoutes < ActiveRecord::Migration[5.2]
  def change
    add_column :brochures, :start_date, :date
    add_column :brochures, :end_date, :date
    add_column :routes, :lat, :decimal, precision: 11, scale: 8, null: true
    add_column :routes, :lng, :decimal, precision: 11, scale: 8, null: true
  end
end
