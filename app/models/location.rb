class Location < ApplicationRecord
	has_many :motels

	validates :city,:state, presence: true
	validates :city, uniqueness: true
end
