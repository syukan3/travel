class ChangeNameDays < ActiveRecord::Migration[5.2]
  def change
    add_column :brochures, :duration, :integer
    remove_column :brochures, :days
  end
end
