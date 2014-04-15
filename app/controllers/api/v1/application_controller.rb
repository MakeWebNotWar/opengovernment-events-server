class Api::V1::ApplicationController < ApplicationController
  before_filter :authenticate_user_from_token!

  protected

  def invalid_login_attempt(message, status = 422)
    render json: {
      success: false, 
      message: message,
    }, status: status
    return
  end

  private

  def authenticate_user_from_token!
    if ensure_params_exist
      user = User.where(email: params[:authentication][:user_email]).first

      if user && Devise.secure_compare(user.authentication_token, params[:authentication][:authentication_token])
        sign_in user, store: false
        return
      else
        invalid_login_attempt("Your Authentication Token is incorrect or expired.  Please reauthenticate.", 401)
      end
    else
      return false
    end
  end
  
  def ensure_params_exist
    if ensure_authentication_token && ensure_user_email
      return true
    else
      return false
    end
  end

  def ensure_authentication_param(name, message=nil, header=nil)
    params[:authentication] ||= {}
    message ||= "#{name} is required."
    name = name.downcase.split
    key = name.join('_').to_sym
    header_key ||= "X-#{name.map(&:capitalize).join('-')}"

    if params[:authentication][key].blank? && request.headers[header_key]
      params[:authentication][key] = request.headers[header_key]
      puts "Key: #{params[:authentication][key]}"
    end

    if params[:authentication][key]
      return true 
    else
      invalid_login_attempt(message, 401)
      return false
    end
  end

  def ensure_authentication_token
    ensure_authentication_param("Authentication Token")
  end

  def ensure_user_email
    ensure_authentication_param("User Email")
  end

  def ensure_user_password
    ensure_authentication_param("User Password")
  end

end