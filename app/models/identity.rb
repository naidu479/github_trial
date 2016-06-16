require 'net/http'

class Identity < ApplicationRecord

  # Autocode: Relationships
  belongs_to :user

  # Autocode: Validations
  validates_presence_of :uid, :provider
  validates_uniqueness_of :uid, :scope => :provider, case_sensitive: false
  validates_presence_of :accesstoken
  validates_uniqueness_of :accesstoken, :scope => :provider, case_sensitive: false

  # Autocode: Callbacks

	# File Upload

	# Soft Destroy


  def self.find_for_oauth(auth)
    identity = self.find_by(provider: auth['provider'], uid: auth['uid'])
  end
    
  def self.create_identity(auth, user_id)
  	identity = self.create!(uid:  auth['uid'], provider: auth['provider'], accesstoken: auth['access_token'], user_id: user_id) 
  end

  def self.validate_auth_data(token, provider)
    if provider == "facebook"
      uri = URI("https://graph.facebook.com/v2.5/me?access_token=#{token}")
      res = JSON.parse(Net::HTTP.get(uri))
    elsif provider = "google"
      uri = URI("https://www.googleapis.com/oauth2/v1/tokeninfo?access_token=#{token}")
      res = JSON.parse(Net::HTTP.get(uri))
    end
  end
 

end
