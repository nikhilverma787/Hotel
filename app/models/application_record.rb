class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
end



# def bookings_params
#     params.require(:bookings).map { |booking_param| booking_param.permit(:name, :contact, :total_person,:room_type,:user_id,:hotel)}
#   end