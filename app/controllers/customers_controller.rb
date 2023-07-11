class CustomersController < ApplicationController
  skip_before_action :authenticate_customer, only: [:create, :login]
  skip_before_action :authenticate_request

  def create 
		user=Customer.new(set_params)
		if user.save 
			render json: user, status: :ok
		else
			render json: {data: user.errors.full_messages, status: "Registration Failed"}, status: :unprocessable_entity
		end
	end

  def login
    if params[:username] && params[:password]
     user = Customer.find_by(username: params[:username],password: params[:password])
       if user
        token = jwt_encode(customer_id: user.id)
        render json: {token: token}, status: :ok
      else
        render json: {error: "Unauthorized"}, status: :unauthorized
      end
    else
      render json: {error: "Username and Passwor field Can't Found"}, status: :unprocessable_entity
    end
  end
  
  def update
    if @current_customer.update(set_params) 
      render json: @current_customer, status: :ok 
    else
      render json: {data: @current_customer.errors.full_messages, status: "Upadation of LandLord Failed"}, status: :unprocessable_entity
    end
  end

  def destroy
    if params[:id].to_i == @current_customer.id
    @current_customer.destroy
    render json: { message: 'Customer Deleted' }, status: :ok
    else 
      render json: {error: "Customer id Invalid"}
    end
  end

  def show
    hotel=Motel.where(status: "open")
    unless hotel.empty?
      render json: hotel
    else
      render json: {error: "No Available Hotel"}
    end
  end
  
  def search_hotel_by_name
    if !(params[:name].strip.empty?)
    check = Motel.where("name like ?", "%"+params[:name].strip+"%" ) 
      unless check.empty?
        render json: check
      else 
        render json: {error: "Hotel not Found"}
      end
    else
      render json: {error: "Hotel field cant be blank"}
    end
    rescue NoMethodError
      render json: {error: "Please select name field"}
  end

  def show_rooms_with_hotel
    unless params[:name].strip.empty?
      hotel=Motel.find_by("name like ?", "%"+params[:name].strip+"%")
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
      render json: {error: "Hotel field cant be Blank"}
    end
    rescue NoMethodError
      render json: {error: "Please select name field"}
  end
  
  def search_by_location
    unless params[:name].strip.empty?
      locate=Location.find_by("city like ?","%"+params[:name].strip.capitalize+"%")
      unless locate.nil?
        check = Motel.where(location_id: locate.id)
        unless check.empty?
          render json: check
        else 
          render json: {error: "Hotel not Found"}
        end
      else
        render json: {error: "Incorrect Location"}
      end
    else
      render json: {error: "City Field cant be Blank"}
    end
    rescue NoMethodError
      render json: {error: "Please select city field"}
  end

  def customer_booking
    check = @current_customer.bookings
    if !(check.empty?)
      render json: @current_customer.bookings
    else 
      render json: {error: "No Bookigs Available"}
    end
  end

  def show_booking_location
    if params[:city]
     check = ActiveRecord::Base.connection.execute("Select bookings.name, bookings.contact, bookings.total_person,bookings.hotel from bookings inner join users on users.id = bookings.user_id inner join rooms on rooms.id=bookings.room_id inner join motels on motels.id=rooms.motel_id inner join locations on locations.id = motels.location_id where users.id=#{@current_customer.id} and locations.city = '#{params[:city].strip.capitalize}'")
      if !(check.empty?)
        render json: check
      else
        render json: {message: "No Bookings"}
      end
    else
      render json: {message: "City field Not Found"}
    end
  end
  
  def particular_detail
    check =  @current_customer.bookings.where(id: params[:id])
    if !(check.empty?)
      render json: check
    else
      render json: {error: "id Can't Find"}
    end
  end

  def see_particular_room_wit_hotel
    unless params[:hotel].strip.empty? && params[:room].strip.empty?
      hotel = Motel.find_by("name like ? ", "%"+params[:hotel].strip.capitalize+"%")
      if !(hotel.nil?)
        room = Room.find_by(category: params[:room].downcase.strip, motel_id: hotel.id)
        if !(room.nil?)
          render json: room
        else
          render json: {message: "room not available"}
        end
      else
        render json: {error: "Hotel Not Available"}
      end 
    else
      render json: {error: "Hotel and Room field cant be Empty"}
    end
    rescue NoMethodError
      render json: {error: "Please select hotel and room field"}
  end

  private
  def set_params 
    params.permit(:type,:name,:username,:password,:mobile)
  end

end
