class Room < ApplicationRecord
	paginates_per 2
	belongs_to :motel
	has_one :booking, dependent: :destroy

	validates :room_number,:category,:limit,:status,:motel_id, presence: true
	validates :status, inclusion: { in: %w(available booked),
    message: "%{value} is not suitable for status only valid available or booked" }
	validates :category, inclusion: { in: %w(deluxe normal sweet),
    message: "%{value} is not category for status only valid deluxe, normal, sweet" }
	validates :room_number,numericality: { only_integer: true }
	# validates :room_number, 
end
