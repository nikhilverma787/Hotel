class BookingPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end

  attr_reader :user, :booking

  def initialize(user, booking)
    @user = user
    @booking = booking
  end

  def create?
    user.Customer? || !user.Landlord?
  end
  def update?
    user.Customer? || !user.Landlord?
  end
  def destroy? 
    user.Customer? || !user.Landlord?
  end

end
