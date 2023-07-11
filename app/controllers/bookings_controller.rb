class BookingsController < ApplicationController
	before_action :authenticate_customer
  skip_before_action :authenticate_request
	
	def create
		count = true
		bookings_params.each do |book_param|
			if hotel = Motel.find_by(name: book_param[:hotel])
				if room_type = Room.find_by(category: book_param[:room_type], status: "available", motel_id: hotel.id)
					if (book_param[:total_person]).to_i <= (room_type.limit).to_i 
						booking = @current_customer.bookings.build(book_param.permit(:name, :contact, :total_person, :hotel, :user_id).merge(room_id: room_type.id))
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
		check = @current_customer.bookings.find_by(id: params[:id])
    if !(check.nil?)
      if check.update(name: params[:name], contact: params[:contact],total_person: params[:total_person],hotel: params[:hotel])
        render json:{message: "Booking update"}, status: :ok 
      else
        render json: {datra: check.errors.full_messages,status: "Upadation of Booking Failed"}, status: :unprocessable_entity
      end
    else
      render json: {status: "Invalid Ids"}, status: :unprocessable_entity
    end
  end

  def destroy
		book=@current_customer.bookings.find_by(id: params[:id])
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
    params.require(:bookings).map { |booking_param| booking_param.permit(:name, :contact, :total_person,:room_type,:user_id,:hotel)}
  end
end	

