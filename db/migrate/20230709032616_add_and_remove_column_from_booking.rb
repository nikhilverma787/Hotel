class AddAndRemoveColumnFromBooking < ActiveRecord::Migration[7.0]
  def change
    remove_column :bookings, :total_room,:integer
    add_column :bookings, :hotel, :string
  end
end
