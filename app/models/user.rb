class User < ApplicationRecord
    require 'securerandom'
    has_secure_password
    has_many :motels, dependent: :destroy
    has_many :bookings, dependent: :destroy

    validates :name,:username,:password_digest,:mobile, presence: true
    validates :username, uniqueness: true, format: { with: /[a-zA-Z0-9]{2,25}@\w{2,8}\.\w{2,5}/,
     message: "only allows mail format"}
    validates :mobile, length: {is: 10}
    validates :type, inclusion: { in: %w(Landlord Customer),
    message: "%{value} is not suitable for status only valid Landlord or Customer" }

    Types = %w{Landlord Customer}
    Types.each do |type_name|
       define_method "#{type_name}?" do
            type == type_name
        end
    end
   
end
