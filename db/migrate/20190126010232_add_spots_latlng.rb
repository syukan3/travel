class AddSpotsLatlng < ActiveRecord::Migration[5.2]
  def change
    add_column :spots, :lat, :decimal, precision: 11, scale: 8, null: true
    add_column :spots, :lng, :decimal, precision: 11, scale: 8, null: true
  end
end
