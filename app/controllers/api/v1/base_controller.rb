
require "#{Rails.root}/lib/errors/errors.rb"

class Api::V1::BaseController < ActionController::API
include Pundit
  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index
  rescue_from Errors::Errors, with: :render_error

  before_action :set_default_response_format,:authenticate_user_from_token!

  private

  def render_error(error)
    render(json: error, status: error.status)
  end

  def set_default_response_format
    request.format = :json
  end

  def authenticate_user_from_token!
    user_token = params[:auth_token].presence
    auth_token =  Authtoken.find_by_token(user_token.to_s)

    user = auth_token.user if auth_token.present?
    
    if user
      sign_in user
    else
      warden.custom_failure!
      render status: 404, json: {error: "Authtoken error/User not found"}
    end
  end


end
