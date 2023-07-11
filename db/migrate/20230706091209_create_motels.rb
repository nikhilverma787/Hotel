class CreateMotels < ActiveRecord::Migration[7.0]
  def change
    create_table :motels do |t|
      t.string :name
      t.string :address
      t.string :contact
      t.string :status

      t.timestamps
    end
  end
end
