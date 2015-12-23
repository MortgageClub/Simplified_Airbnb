class Room < ActiveRecord::Base
  belongs_to :user
  has_many :photos
  has_many :reservations, dependent: :destroy
  has_many :reviews

  geocoded_by :address
  after_validation :geocode, if: :address_changed?

  validates :home_type, presence: true
  validates :room_type, presence: true
  validates :accommodate, presence: true
  validates :bed_room, presence: true
  validates :bath_room, presence: true
  validates :listing_name, presence: true, length: {maximum: 50}
  validates :summary, presence: true, length: {maximum: 500}
  validates :address, presence: true
  validates :price, presence: true

  def show_image_first(type)
    photos.empty? ? "/system/photos/default.jpg" : photos.first.image.url(type)
  end

  def average_rating
    reviews.empty? ? 0 : reviews.average(:star).round(2)
  end
end
