class AddBrochureId < ActiveRecord::Migration[5.2]
  def change
    add_column :members, :brochure_id, :integer

  end
end
