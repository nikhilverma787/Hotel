class ApplicationController < ActionController::API
 include JsonWebToken
  before_action :authenticate_request
  before_action :landlord_check
  before_action :customer_check

  before_action do
    ActiveStorage::Current.url_options = { protocol: request.protocol, host: request.host, port: request.port }
  end

  private
  def authenticate_request
    begin
      header = request.headers["Authorization"]
      header = header.split(" ").last if header
      decoded = jwt_decode(header)
      @current_user = User.find(decoded[:user_id])
    rescue Exception => e 
      render json: {data: e, error: "First Login Yourself"}
    end
  end

   def landlord_check
    unless @current_user.type == 'Landlord' 
      render json: { error: 'You are not a Landlord' }
      end 
   end
   
    def customer_check
    unless @current_user.type == 'Customer' 
      render json: { error: 'You are not a Landlord' }
      end 
   end
end
