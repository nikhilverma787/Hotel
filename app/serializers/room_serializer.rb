class RoomSerializer < ActiveModel::Serializer
  attributes :id,:room_number,:category,:limit,:status
end
