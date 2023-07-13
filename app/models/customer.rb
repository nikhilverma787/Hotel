class Customer < User
    validates :name,:username,:password_digest,:mobile, presence: true
    validates :username, uniqueness: true, format: { with: /[a-zA-Z0-9]{2,25}@\w{2,8}\.\w{2,5}/,
    message: "only allows letters"}
    validates :mobile, length: {is: 10}
    #  validates :type, inclusion: { in: %w(Landlord Customer),
    # message: "%{value} is not suitable for status only valid Landlord or Customer" }
end