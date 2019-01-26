class DestroyMemberIdFromBrochures < ActiveRecord::Migration[5.2]
  def change
    remove_column :brochures, :member_id, :integer
  end
end
