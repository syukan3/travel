class CreateDays < ActiveRecord::Migration[5.2]
  def change
    create_table :days do |t|
      t.integer :brochure_id
      t.time :start_time

      t.timestamps
    end
  end
end
