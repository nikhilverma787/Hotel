class BookingsController < ApiController
	before_action :authenticate_request
  before_action :check_auth
  
	def create
		count = true
		bookings_params.each do |book_param|
			if hotel = Motel.find_by(id: book_param[:motel_id])
				if room_type = Room.find_by(category: book_param[:room_type], status: "available", motel_id: book_param[:motel_id],id: book_param[:room_id])
					#Room.where(id: 1, category: "deluxe",motel_id: 1, status: "available")
					if (book_param[:total_person]).to_i <= (room_type.limit).to_i 
						booking = @current_user.bookings.build(book_param.permit(:name, :contact, :total_person, :user_id, :motel_id, :room_id))
						if booking.save
							room_type.update(status: "booked")
						else
							count = false
							render json: { message: booking.errors.full_messages.first }
							break
						end
					else
						count = false
						render json: { message: "In one Room Only 2 Person Allowed" }
						break
					end
				else
					count = false
					render json: { message: "Rooms not available"}
					break
				end
			else
				count = false
				render json: { message: "Hotel not found" }
				break
			end
	  end
		if count
			render json: { message: 'Bookings created successfully' }, status: :created
		end
	end

	def update
		check = @current_user.bookings.find_by(id: params[:id])
    return render json: {status: "Invalid Ids"}, status: :unprocessable_entity unless (check.present?)
    
     return render json:{message: "Booking update"}, status: :ok  if check.update(name: params[:name], contact: params[:contact],total_person: params[:total_person])
        render json: {datra: check.errors.full_messages,status: "Upadation of Booking Failed"}, status: :unprocessable_entity      
  end

  def destroy
		book=@current_user.bookings.find_by(id: params[:id])
		if !(book.nil?)
			if params[:id].to_i == book.id
				book.destroy
				render json: { message: 'Booking Deleted' }, status: :ok
			end
    else 
      render json:{ message: 'Booking not Found' }, status: :unprocessable_entity
    end
  end
	
	private
	
	def bookings_params
    params.require(:bookings).map { |booking_param| booking_param.permit(:name, :contact, :total_person,:room_type,:user_id,:motel_id,:room_id)}
  end
  def check_auth
  	authorize Booking
  end
end	

