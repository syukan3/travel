class ChangeMemberColumn < ActiveRecord::Migration[5.2]
  def change
    add_column :members, :brochure_id, :integer
    remove_column :members, :room_id, :integer
  end
end
