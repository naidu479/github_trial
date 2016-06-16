class Api::V1::Users::SessionsController < Api::V1::BaseController

  skip_before_filter :authenticate_user_from_token!, :only => [:create]
skip_after_action :verify_authorized

  def create
    @user = User.find_for_database_authentication(signin_parameters)
    return user_not_found unless @user
   
    if @user.valid_password?(signin_parameters[:password])
      sign_in(@user)
       @auth_token = Authtoken.create_auth_token(@user.id,request.remote_ip, request.user_agent, signin_parameters[:device_id])
      render json: {auth_token:@auth_token.token}
    else
      invalid_login_attempt
    end
  end

  def destroy
    user_token = params[:auth_token].presence
    auth_token =  Authtoken.find_by_token(user_token.to_s)

    user  = auth_token.user if auth_token.present?

    if user
      sign_out(user)
      Authtoken.destroy_auth_token(user_token.to_s)
      render status: 200, json: {message: "user succesfully logged out."}
    else
      user_not_found
    end
  end

  def signin_parameters
    params.require(:user).permit( :email, :username, :password, :device_id)
  end

  def invalid_login_attempt
    warden.custom_failure!
    render status: 400, json: {error: "Error with your email or password"}
  end

  def user_not_found
    render status: 404, json: {error: "User not found"}
  end

end

