class DestroyBrochureModelForScaffold < ActiveRecord::Migration[5.2]
  def change
    drop_table :brochures
  end
end
