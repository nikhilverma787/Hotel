class User < ApplicationRecord
    require 'securerandom'
    has_secure_password
    has_many :motels, dependent: :destroy
    has_many :bookings

    validates :type, inclusion: { in: %w(Landlord Customer),
    message: "%{value} is not suitable for status only valid Landlord or Customer" }
end
