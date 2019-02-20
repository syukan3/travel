class ChangePublicFlag < ActiveRecord::Migration[5.2]
  def change
    add_column :brochures, :public_flag, :boolean
    remove_column :brochures, :public

  end
end
