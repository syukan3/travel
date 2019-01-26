class Change < ActiveRecord::Migration[5.2]
  def change
    add_column :brochures, :days, :integer
    remove_column :brochures, :end_date
  end
end
