class CreateSpots < ActiveRecord::Migration[5.2]
  def change
    create_table :spots do |t|
      t.integer :day_id
      t.string :location_name
      t.time :start_time
      t.integer :numbering

      t.timestamps
    end
  end
end
