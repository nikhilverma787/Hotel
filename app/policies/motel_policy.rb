class MotelPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end

  attr_reader :user, :motel

  def initialize(user, motel)
    @user = user
    @motel = motel
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
