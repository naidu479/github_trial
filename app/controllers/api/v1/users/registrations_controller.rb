class Api::V1::Users::RegistrationsController < Api::V1::BaseController

  skip_before_filter :authenticate_user_from_token!, :only => [:create]

  def create
    if signup_parameters[:social_auth]
      auth = signup_parameters[:social_auth].to_h
      identity = Identity.find_for_oauth(auth)
      return invalid_signup_attempt if identity.present?

      if identity.present?
        validated_res = Identity.validate_auth_data(auth['access_token'],auth['provider'])
        return invalid_access_token if (!validated_res['id'] && !validated_res['user_id'])

        sign_in(identity.user)
        identity.update_attribute(:accesstoken, auth['access_token'])
        auth_token = Authtoken.create_auth_token(identity.user.id,request.remote_ip, request.user_agent, signup_parameters[:device_id])
        render json: {auth_token:auth_token.token}
      else

        validated_res = Identity.validate_auth_data(auth['access_token'],auth['provider'])
        return invalid_access_token if (!validated_res['id'] && !validated_res['user_id'])

        user = User.new( email: auth['email'] || "" )

        if user.save(validate: false)
         identity = Identity.create_identity(auth, user.id)
         generate_authtoken(user)
        else
          send_failure_res(user)
        end
      end

    elsif signup_parameters[:email]
      user = User.new signup_parameters

      if user.save
        generate_authtoken(user)
      else
        send_failure_res(user)
      end

    else
      render status: 400, json: {error: "Please pass correct parameters"}
    end

  end

  protected

  def generate_authtoken(user)
    auth_token = Authtoken.create_auth_token(user.id,request.remote_ip, request.user_agent, signup_parameters[:device_id])
    render json: {message: "#{user.email} was succesfully created", auth_token: auth_token.token}
  end

  def send_failure_res(user)
    render status: 400, json: {error: user.errors.full_messages }
  end

  def invalid_signup_attempt
    render status: 403, json: {error: "Identity already present"}
  end

  def invalid_access_token
    render status: 400, json: {error: "Access Token is Invalid - Oauth Exception"}
  end

  def signup_parameters
    params.require(:user).permit( :email,:password, :password_confirmation, :device_id,:social_auth =>[:provider,:access_token,:uid,:email])
  end
end


