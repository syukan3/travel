class AddSpotsTimeRequired < ActiveRecord::Migration[5.2]
  def change
    add_column :spots, :time_required, :integer

  end
end
