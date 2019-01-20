class ChangeRoomAndMember < ActiveRecord::Migration[5.2]
  def change
    add_column :members, :room_id, :integer
    remove_column :rooms, :member_id, :integer
  end
end
