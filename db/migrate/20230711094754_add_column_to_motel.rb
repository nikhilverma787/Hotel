class AddColumnToMotel < ActiveRecord::Migration[7.0]
  def change
    add_column :motels, :image, :binary
  end
end
