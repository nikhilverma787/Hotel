class MotelSerializer < ActiveModel::Serializer
  attributes :id,:name,:address,:contact,:status,:image
  
  def image
    object.image.url
  end
end
