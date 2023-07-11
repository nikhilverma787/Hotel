class CreateBookings < ActiveRecord::Migration[7.0]
  def change
    create_table :bookings do |t|
      t.string :name
      t.integer :contact
      t.integer :total_person
      t.integer :total_room

      t.timestamps
    end
  end
end
