class Api::V1::Users::RegistrationsController < Api::V1::BaseController

  skip_before_filter :authenticate_user_from_token!, :only => [:create]
  
  def create
    @user = User.new signup_parameters
    if @user.save
      @auth_token = Authtoken.create_auth_token(@user.id,request.remote_ip, request.user_agent, signup_parameters[:device_id])
      render json: {message: "#{@user.email} was succesfully created", auth_token: @auth_token.token}
    else
      render json: {error: @user.errors.full_messages }
    end
  end

  protected

  def signup_parameters
    params.require(:user).permit( :email,:password,:password_confirmation,:device_id)
  end
end


