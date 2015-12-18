class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :omniauthable

  validates :fullname, presence: true, length: {maximum: 50}

  has_many :rooms
  has_many :reservations

  def self.from_omniauth(auth)
    user = User.find_by_email(auth.info.email) || User.find_by_provider_and_uid(auth.provider, auth.uid)
    user = create_user_from_auth(auth) unless user
    user
  end

  def self.create_user_from_auth(auth)
    User.create(
      fullname: auth.info.name,
      provider: auth.provider,
      uid: auth.uid,
      email: auth.info.email,
      image: auth.info.image,
      password: Devise.friendly_token[0, 20]
    )
  end
end
