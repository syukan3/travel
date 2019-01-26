class AddPeriodAndLatlngToBrochureAndRoutes < ActiveRecord::Migration[5.2]
  def change
    add_column :brochures, :start_date, :date
    add_column :brochures, :end_date, :date

  end
end
