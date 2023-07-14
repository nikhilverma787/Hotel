class LandlordsController < ApiController
  before_action :authenticate_request
  before_action :check_auth
  
  def show_hotels
    authorize User
    check = @current_user.motels
    return render json: check.page(params[:page]).per(params[:per_page]) unless (check.empty?) 
      render json: {error: "Hotel not Found"}
  end

  def show_by_name
    return render json: {error: "Hotel name field cant empty"} unless params[:name].present?
    check = @current_user.motels.where("name LIKE ?","%"+params[:name].strip.capitalize+"%")

      return render json: check unless check.empty?
          render json: {error: "Hotel not Found"}
  end

  def show_by_location
    return render json: {error: "Location field Can't Found"}, status: :unprocessable_entity unless params[:location_id].present?
      locate=Location.find_by(id: params[:location_id])

      return render json: {error: "Invalid Location"} if locate.nil?
        check = @current_user.motels.where(location_id: locate.id)

        return render json: check.page(params[:page]).per(params[:per_page]) unless check.empty?
          render json: {error: "Hotel not Found"}
  end

  def show_rooms_with_hotel
    return render json: {error: "Hotel field Can't be Empty"}, status: :unprocessable_entity unless params[:motel_id].present?
      hotel=@current_user.motels.find_by(id: params[:motel_id])

      return render json: {error: "Hotel not Found"} if hotel.nil?
        check = hotel.rooms.page(params[:page]).per(params[:per_page])

        return render json: check unless check.empty?
          render json: {error: "No Available Rooms"}
  end

  def show_bookings_in_motel
    return render json: { error: 'Motel Field not found' } unless params[:motel_id].present?
      check = Motel.find_by(id: params[:motel_id],user_id: @current_user.id)

      return render json: { error: 'Hotel not Found' } if check.nil?
        book = Booking.where(motel_id: params[:motel_id])

        return render json: book if book.present?
          render json: { message: 'No Bookin Available' }
  end

  def delete_booking_in_motel
    if (params[:room_id].present? && params[:motel_id].present?)
     check = Booking.find_by(room_id: params[:room_id], motel_id: params[:motel_id])
      unless check.nil?
      render json: check.destroy, status: :ok
      else
        render json: { error: 'That room not available in your Hotel' }
      end
    else
      render json: { error: 'Room and Motel field not Found' }
    end
  end
 
  private

  def set_params 
    params.permit(:type,:name,:username,:password,:mobile)
  end

   def check_auth
    authorize User
  end
end
