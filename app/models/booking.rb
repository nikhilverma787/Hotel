class Booking < ApplicationRecord
	belongs_to :room
	belongs_to :user

	validates :name,:contact,:total_person,:hotel,:user_id,:room_id, presence: true
end
