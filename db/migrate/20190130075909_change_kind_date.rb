class ChangeKindDate < ActiveRecord::Migration[5.2]
  def change
    remove_column :brochures, :start_date
  end
end
