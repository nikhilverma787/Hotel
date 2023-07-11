class RoomsController < ApplicationController
	before_action :authenticate_request
  skip_before_action :authenticate_customer
  
  def create 
    if params[:hotel] 
      if check =  @current_landlord.motels.find_by(name: params[:hotel].strip.capitalize)
        room=Room.new((set_params).merge(motel_id: check.id))
        if room.save 
          render json: room, status: :ok
        else
          render json: {data: room.errors.full_messages, status: "Room Creation Failed"}, status: :unprocessable_entity
        end
      else
        render json: {error: "You have not Owner of #{params[:hotel]}"}, status: :unprocessable_entity
      end
    else 
      render json: {error: "Hotel Field can't Found"}
    end
	end

  def room_created_by_location 
    if params[:hotel] && params[:location]
      locate= Location.find_by(city: params[:location])
      if !(locate.nil?)
        if check =  @current_landlord.motels.find_by(name: params[:hotel], )
          room=Room.new((set_params).merge(motel_id: check.id))
          if room.save 
            render json: room, status: :ok
          else
            render json: {data: room.errors.full_messages, status: "Room Creation Failed"}, status: :unprocessable_entity
          end
        else
          render json: {error: "You have not Owner of #{params[:hotel]}"}, status: :unprocessable_entity
        end
      else
        render json: {error: "Location Invalid"}, status: :unprocessable_entity
      end
    else 
      render json: {error: "Hotel & Location Field can't Found"}
    end
	end

	# def update
    
  #     check = Room.find_by(id: params[:id])
  #     if check.update(set_params)
  #       render json:{message: "Room update"}, status: :ok 
  #     else
  #       render json: {error: check.errors.full_messages ,status: "Upadation of Room Failed"}, status: :unprocessable_entity
  #     end
    
  # rescue NoMethodError
  #   render json: {error: "Id not found"}
  # end

  def update
    room = Room.find_by(id: params[:id])
    if !(room.nil?)
      motel = Motel.find_by(id: room.motel_id)
      if !(motel.nil?)
        check= @current_landlord.id == motel.user_id 
        if check
          room.update(set_params)
          render json: {message: "Room update"}
        else 
          render json: {error: "Room you want to update is not available in your Motels"}
        end
      else
        render json: {error: "Room you want to update is not available Motel"}
      end
    else 
      render json: {error: "Invalid Room Id"}
    end
  end

  def destroy
    room = Room.find_by(id: params[:id])
    if !(room.nil?)
      motel = Motel.find_by(id: room.motel_id)
      if !(motel.nil?)
        check= @current_landlord.id == motel.user_id 
        if check
          room.destroy
          render json: {message: "Room Delete"}
        else 
          render json: {error: "Room you want to delete is not available in your Motels"}
        end
      else
        render json: {error: "Room you want to delete is not available Motel"}
      end
    else 
      render json: {error: "Invalid Room Id"}
    end
  end

  private
  def set_params 
    params.permit(:room_number, :category, :limit, :status)
  end
end