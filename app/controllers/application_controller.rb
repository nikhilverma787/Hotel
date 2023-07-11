class ApplicationController < ActionController::API
  include JsonWebToken
  before_action :authenticate_request, :authenticate_customer

  before_action do
    ActiveStorage::Current.url_options = { protocol: request.protocol, host: request.host, port: request.port }
  end

  private
  def authenticate_request
    begin
      header = request.headers["Authorization"]
      header = header.split(" ").last if header
      decoded = jwt_decode(header)
      @current_landlord = User.find(decoded[:owner_id])
    rescue Exception => e 
      render json: {data: e, error: "First Login Yourself"}
    end
  end
  def authenticate_customer
    begin
      header = request.headers["Authorization"]
      header = header.split(" ").last if header
      decoded = jwt_decode(header)
      @current_customer = User.find(decoded[:customer_id])
    rescue Exception => e 
      render json: {data: e, error: "First Login Yourself"}
    end 
  end
end
