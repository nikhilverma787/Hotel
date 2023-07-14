class RoomPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end

  attr_reader :user, :room

  def initialize(user, room)
    @user = user
    @room = room
  end

  def create?
    user.Landlord? || !user.Customer?
  end
  def update?
    user.Landlord? && !user.Customer?
  end
  def destroy? 
    user.Landlord? || !user.Customer?
  end
end
