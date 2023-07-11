class LandlordsController < ApplicationController
  skip_before_action :authenticate_request, only: [:create, :login]
  skip_before_action :authenticate_customer

  
  
 def create 
		@user=Landlord.new(set_params)
		if @user.save 
			render json: @user, status: :ok
		else
			render json: {data: @user.errors.full_messages, status: "Registration Failed"}, status: :unprocessable_entity
		end
	end

  def login
    if params[:username] && params[:password]
    @user = Landlord.find_by(username: params[:username],password: params[:password])
      if @user
        token = jwt_encode(owner_id: @user.id)
        render json: {token: token}, status: :ok
      else
        render json: {error: "Unauthorized"}, status: :unauthorized
      end
    else
      render json: {error: "Username and Passwor field Can't Found"}, status: :unprocessable_entity
    end
  end

  def update
    #if params[:id].to_i == @current_landlord.id
      if @current_landlord.update(set_params) 
          render json: @current_landlord, status: :ok 
      else
        render json: {data: @current_landlord
          .errors.full_messages, status: "Upadation of LandLord Failed"}, status: :unprocessable_entity
      end
    # else 
    #   render json: {error: "Landlord id Invalid"}
    # end
  end

  def destroy
    #if params[:id].to_i == @current_landlord.id
    if @current_landlord.destroy
      render json: { message: 'LandLord Deleted' }, status: :ok
    else 
      render json: {error: "Landlord id Invalid"}
    end
  end

  def show
    render json: @current_landlord
  end
  
  def show_hotels
    check = @current_landlord.motels
    unless (check.empty?)
      render json: check
    else 
      render json: {error: "Hotel not Found"}
    end
  end

  def show_name
    unless params[:name].strip.empty?
    check = @current_landlord.motels.find_by("name like ?", "%"+params[:name].strip.capitalize+"%")
      unless check.nil?
        render json: check
      else 
        render json: {error: "Hotel not Found"}
      end
    else 
      render json: {error: "Hotel name field cant empty"}
    end
    rescue NoMethodError
      render json: {error: "Please select name field"}
  end

  def show_by_location
    unless params[:city].strip.empty?
      locate=Location.find_by("city like ?", "%"+params[:city].strip.capitalize+"%")
      unless locate.nil?
        check = @current_landlord.motels.where(location_id: locate.id)
        unless check.empty?
          render json: check
        else 
          render json: {error: "Hotel not Found"}
        end
      else 
        render json: {error: "Invalid Location"}
      end  
    else
      render json: {error: "Location field Can't Found"}, status: :unprocessable_entity
    end
    rescue NoMethodError
      render json: {error: "Please select city field"}
  end

  def show_rooms_with_hotel
    unless params[:name].strip.empty?
      hotel=@current_landlord.motels.find_by("name like ?", "%"+params[:name].strip.capitalize+"%")
      unless hotel.nil?
        check = hotel.rooms
        unless check.empty?
          render json: check
        else 
          render json: {error: "No Available Rooms"}
        end
      else
        render json: {error: "Hotel not Found"}
      end
    else
      render json: {error: "Hotel field Can't be Empty"}, status: :unprocessable_entity
    end
    rescue NoMethodError
      render json: {error: "Please select name field"}
  end
 
  private
  def set_params 
    params.permit(:type,:name,:username,:password,:mobile)
  end
end
