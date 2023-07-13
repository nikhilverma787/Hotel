class RemoveColumnFromBooking < ActiveRecord::Migration[7.0]
  def change
    add_column :bookings, :motel_id, :integer
    remove_column :bookings, :hotel, :string
  end
end
