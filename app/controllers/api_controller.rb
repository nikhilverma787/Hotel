class ApiController < ActionController::API
    include JsonWebToken
    include Pundit::Authorization
     before_action :authenticate_request
     around_action :pundit_check
     # before_action :landlord_check
     # before_action :customer_check
   
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
   
     #  def landlord_check
     #   unless @current_user.type == 'Landlord' 
     #     render json: { error: 'You are not a Landlord' }
     #     end 
     #  end
      
     #   def customer_check
     #   unless @current_user.type == 'Customer' 
     #     render json: { error: 'You are not a Landlord' }
     #     end 
     #  end
   
     def current_user
       @current_user
     end

     def pundit_check
        yield
        rescue Pundit::NotAuthorizedError
            render json: { error: 'You Dont have persmission to do this actions' }
     end 
end