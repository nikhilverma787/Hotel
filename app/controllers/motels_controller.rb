class MotelsController < ApplicationController
  before_action :authenticate_request
  skip_before_action :authenticate_customer
 
  def create 
    if params[:location]  
      locate=Location.find_by(city: params[:location].strip.capitalize)
      if !(locate.nil?)
        @motel=Motel.new((set_params).merge(location_id: locate.id))
        @motel.image.attach(params[:image])
        @motel.user_id=@current_landlord.id
        if @motel.save 
          render json: @motel#{motel_name: @motel.name, motel_image: @motel.image.url} , status: :ok
        else
          render json: {data: @motel.errors.full_messages, status: "Registration Failed"}, status: :unprocessable_entity
        end
      else
        render json: {error: "Location Not Register to create Motel"}
      end 
    else
      render json: {error: "Location field can't Found"}
    end
	end

	def update
    check = @current_landlord.motels.find_by(id: params[:id])
    if !(check.nil?)
      if check.update(set_params)
        render json: check
      else
        render json: {error: check.errors.full_messages ,status: "Upadation of Motel Failed"}, status: :unprocessable_entity
      end
    else
      render json: {error: check.errors.full_messages ,status: "Upadation of Motel Failed"}, status: :unprocessable_entity
    end
  rescue NoMethodError
    render json: {error: "Id not found"}
  end

  def destroy
    current=@current_landlord.motels.find_by(id: params[:id])
    if params[:id].to_i ==  current.id
      if !(current.nil?)
        current.destroy
        render json: { message: 'Motel Deleted' }, status: :ok
      end
    else 
      render json:{ message: 'Motel not Found' }, status: :unprocessable_entity
    end
  rescue NoMethodError
    render json: {error: "Id not found"}
  end

  private
  def set_params 
    params.permit(:name, :address, :contact, :status, :user_id,:image)
  end
end