class UsersController < ApiController
  skip_before_action :authenticate_request, only: [:create,:login]

	def create 
		user=User.new(set_params)
		if user.save 
			render json: user, status: :ok
		else
			render json: {data: user.errors.full_messages, status: "Registration Failed"}, status: :unprocessable_entity
		end
	end

  def login
    if params[:username] && params[:password_digest]
    user = User.find_by(username: params[:username],password_digest: params[:password_digest])
      if user
        token = jwt_encode(user_id: user.id)
        render json: {token: token}, status: :ok
      else
        render json: {error: "Unauthorized"}, status: :unauthorized
      end
    else
      render json: { error: 'Username and Passwor field Can not Found' }, status: :unprocessable_entity
    end
  end

  def update
    return render json: @current_user, status: :ok  if @current_user.update(set_params) 
      render json: {data: @current_user.errors.full_messages, status: "Upadation of LandLord Failed"}, status: :unprocessable_entity
  end

  def destroy
    return render json: { message: 'Customer Deleted' }, status: :ok if  @current_user.destroy
      render json: {error: 'User Not deleted' }
  end

 def show
  render json: @current_user
 end

  private

  def set_params 
    params.permit(:type,:name,:username,:password_digest,:mobile)
  end
end