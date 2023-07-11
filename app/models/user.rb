class User < ApplicationRecord
    has_many :motels
    has_many :bookings
end
