class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and 
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable

  serialize :omniauth_hash
  has_many :goal_integrations

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.omniauth_hash = auth.to_h
      user.strava_token = strava_access_token(auth.to_h)
    end
  end

  def display_name
    strava_info[:name] || email
  end

  def strava_info
    omniauth_hash && omniauth_hash.with_indifferent_access[:info] || {}
  end

  def strava_credentials
    omniauth_hash && omniauth_hash.with_indifferent_access[:credentials] || {}
  end

  def self.strava_access_token(ohash)
    ohash.with_indifferent_access[:credentials][:token]
  end

end
