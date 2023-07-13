class Booking < ApplicationRecord
	paginates_per 2
	belongs_to :room
	belongs_to :user

	validates :name,:contact,:total_person,:user_id,:room_id, presence: true
end
