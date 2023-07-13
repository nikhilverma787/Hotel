class MotelsController < ApplicationController
  before_action :authenticate_request
  skip_before_action :customer_check
  before_action :landlord_check
  def create 
    return render json: {error: "Location field can't Found"} unless params[:location_id].present?  
      locate=Location.find_by(id: params[:location_id])

      return render json: {error: "Location Not Register to create Motel"} if (locate.nil?)
        motel=Motel.new(set_params)
        motel.image.attach(params[:image])
        motel.user_id=@current_user.id

        return render json: motel if motel.save 
          render json: {data: motel.errors.full_messages, status: "Registration Failed"}, status: :unprocessable_entity
	end

	def update
    check = @current_user.motels.find_by(id: params[:id])
    return render json: {error: check.errors.full_messages ,status: "Upadation of Motel Failed"}, status: :unprocessable_entity if (check.nil?)

      return render json: check if check.update(set_params)
        render json: {error: check.errors.full_messages ,status: "Upadation of Motel Failed"}, status: :unprocessable_entity

    rescue NoMethodError
      render json: {error: "Id not found"}
  end

  def destroy
    current=@current_user.motels.find_by(id: params[:id])
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
    params.permit(:name, :address, :contact, :status,:image,:location_id)
  end

end