class CreateRooms < ActiveRecord::Migration[7.0]
  def change
    create_table :rooms do |t|
      t.integer :room_number
      t.string :category
      t.string :limit
      t.string :status

      t.timestamps
    end
  end
end
