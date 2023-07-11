class LocationsController < ApplicationController
  skip_before_action :authenticate_request
  skip_before_action :authenticate_customer

  def show 
    render json: {data: Location.all}
  end
  
end