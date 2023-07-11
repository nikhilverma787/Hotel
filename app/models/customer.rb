class Customer < User
    validates :name,:username,:password,:mobile, presence: true
    validates :username, uniqueness: true, format: { with: /[a-zA-Z0-9]{2,25}@\w{2,8}\.\w{2,5}/,
    message: "only allows letters"}
    validates :mobile, length: {is: 10}
end