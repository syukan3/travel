class DestroyRoomIdOfBrochure < ActiveRecord::Migration[5.2]
  def change
    remove_column :brochures, :room_id, :integer

  end
end
