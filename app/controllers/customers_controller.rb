class CustomersController < ApiController
  before_action :authenticate_request
  before_action :check_auth

  def show_open_hotels
    hotel=Motel.where(status: 'open')
    return render json: hotel.page(params[:page]).per(params[:per_page]) unless hotel.empty?
      render json: { error: 'No Available Hotel' }
  end
  
  def search_hotel_by_name
    return render json: { error: 'Hotel field cant be blank' } unless params[:name].present?
      check = Motel.where("name like ?", "%"+params[:name].strip+"%" ) 

        return render json: check  unless check.empty?
          render json: { error: 'Hotel not Found' }
  end

  def show_rooms_with_hotel
    return render json: { error: 'Hotel field cant be Blank' } unless params[:motel_id].present?
      hotel=Motel.find_by(id: params[:motel_id])

      return render json: {error: "Hotel not Found"} if hotel.nil?
        check = hotel.rooms

        return render json: check unless check.empty?
          render json: { error: 'No Available Rooms' }
  end
  
  def search_by_location
    return render json: { error: 'Location Field cant be Blank' } unless params[:location_id].present?
      locate=Location.find_by(id: params[:location_id])

      return render json: { error: 'Incorrect Location' } if locate.nil?
        check = Motel.where(location_id: locate.id)

        return render json: check.page(params[:page]).per(params[:per_page]) unless check.empty?
          render json: { error: 'Hotel not Found' }
  end
#....................Customer Bookings ........
  def customer_booking
    check = @current_user.bookings
    return render json: @current_user.bookings.page(params[:page]).per(params[:per_page]) unless (check.empty?)
      render json: { error: 'No Bookigs Available' }
  end

  def show_booking_location
    return render json: {message: "Location field Not Found"} unless params[:location_id].present?
     check = ActiveRecord::Base.connection.execute("Select bookings.name, bookings.contact, bookings.total_person from bookings inner join users on users.id = bookings.user_id inner join rooms on rooms.id=bookings.room_id inner join motels on motels.id=rooms.motel_id inner join locations on locations.id = motels.location_id where users.id=#{@current_user.id} and locations.id = '#{params[:location_id]}'")

      return render json: check unless (check.empty?)
        render json: {message: "No Bookings"}
 end
  
  def particular_detail
    check =  @current_user.bookings.where(id: params[:id])
    return render json: check unless (check.empty?)
      render json: {error: "id Can't Find"}
  end

  def see_particular_room_with_hotel
    return render json: {error: "Hotel and Room field cant be Empty"} unless (params[:motel_id].present? && params[:room_id].present?)
      hotel = Motel.find_by(id: params[:motel_id])

      return render json: {error: "Hotel Not Available"} if (hotel.nil?)
        room = Room.find_by(id: params[:room_id])

        return render json: room unless (room.nil?)
          render json: {message: "room not available"}
  end

  private

  def check_auth
    authorize User
  end
end
