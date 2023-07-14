class Motel < ApplicationRecord
	paginates_per 2
	belongs_to :user
	belongs_to :location
	has_many :rooms, dependent: :destroy
	has_one_attached :image
	validates :name,:address,:contact,:status,:location_id,:image, presence: true
	validates :name, uniqueness: true
	validates :status, inclusion: { in: %w(open closed),
    message: "%{value} is not suitable for status only valid open or closed" }

  before_save :check_capitalize
  private
  
  def check_capitalize
    self.name.capitalize  
  end
end
