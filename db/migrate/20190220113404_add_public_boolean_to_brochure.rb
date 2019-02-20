class AddPublicBooleanToBrochure < ActiveRecord::Migration[5.2]
  def change
    add_column :brochures, :public, :boolean

  end
end
