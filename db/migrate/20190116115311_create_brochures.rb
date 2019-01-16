class CreateBrochures < ActiveRecord::Migration[5.2]
  def change
    create_table :brochures do |t|
      t.integer :room_id
      t.string :title
      t.string :departure
      t.string :arrival

      t.timestamps
    end
  end
end
