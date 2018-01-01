class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: %i[instagram]

  validates :username, uniqueness: true

  def email_required?
    false
  end

  def email_changed?
    false
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      # auth.extra.raw_info
      # <OmniAuth::AuthHash bio="" full_name="Xavier" id="3465743392" is_business=false profile_picture="https://scontent-otp1-1.cdninstagram.com/t51.2885-19/11906329_960233084022564_1448528159_a.jpg" username="seuqra" website="">
      # user.email = "#{auth.extra.raw_info.username}@gmail.com"
      user.password = Devise.friendly_token[0,20]
      user.provider = auth.provider
      user.uid = auth.uid
      user.username = auth.extra.raw_info.username   # assuming the user model has a name
      user.profile_picture = auth.extra.raw_info.profile_picture # assuming the user model has an image
      # If you are using confirmable and the provider(s) you use validate emails,
      # uncomment the line below to skip the confirmation emails.
      # user.skip_confirmation!
    end
  end
end
