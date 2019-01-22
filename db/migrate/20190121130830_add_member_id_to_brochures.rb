class AddMemberIdToBrochures < ActiveRecord::Migration[5.2]
  def change
    add_column :brochures, :member_id, :integer

  end
end
