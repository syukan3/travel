class ChangeNameStayTimeOfSpot < ActiveRecord::Migration[5.2]
  def change
    add_column :spots, :stay_time, :integer
    remove_column :spots, :time_required
  end
end
