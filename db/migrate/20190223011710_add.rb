class Add < ActiveRecord::Migration[5.2]
  def change
    add_column :spots, :position, :integer
    remove_column :spots, :numbering
  end
end
