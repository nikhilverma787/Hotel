class AddReferencesToBooking < ActiveRecord::Migration[7.0]
  def change
    add_reference :bookings, :user, null: false, foreign_key: true
    add_reference :bookings, :room, null: false, foreign_key: true
  end
end
