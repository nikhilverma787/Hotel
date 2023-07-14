class LocationsController < ApiController
  def show 
    render json: {data: Location.all}
  end
  
end