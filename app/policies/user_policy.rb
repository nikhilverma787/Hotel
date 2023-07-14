class UserPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end

  attr_reader :user, :type

  def initialize(user, type)
    @user = user
    @type = type
  end
#...................................Customer...........................
  def show_open_hotels?
    user.Customer? || !user.Landlord?
  end
  def search_hotel_by_name?
    user.Customer? || !user.Landlord?
  end
  def show_rooms_with_hotel?
    user.Customer? || !user.Landlord?
  end
  def search_by_location?
    user.Customer? || !user.Landlord?
  end
  def customer_booking?
    user.Customer? || !user.Landlord?
  end
  def show_booking_location?
    user.Customer? || !user.Landlord?
  end
  def particular_detail?
    user.Customer? || !user.Landlord?
  end
  def see_particular_room_with_hotel?
    user.Customer? || !user.Landlord?
  end
  #....................................Landlord..............................
  def show_hotels?
    user.Landlord? || !user.Customer?
  end
  def show_by_name?
    user.Landlord? || !user.Customer?
  end
  def show_by_location?
    user.Landlord? || !user.Customer?
  end
  def show_rooms_with_hotel?
    user.Landlord? || !user.Customer?
  end
  def show_bookings_in_motel?
    user.Landlord? || !user.Customer?
  end
  def delete_booking_in_motel?
    user.Landlord? || !user.Customer?
  end
 
end
