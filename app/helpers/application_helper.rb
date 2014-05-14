module ApplicationHelper

  protected

  def invalid_login_attempt(message, status = 401)
    invalid_attempt(message, nil, status)
  end

  def invalid_attempt(message, object = nil, status = 500)
    
    response = {
      success: false, 
      message: message,
      params: params
    }

    if object && object.errors
      response.merge!(errors: object.errors.full_messages)
    end

    render json: response, status: status
    return
  end

  def current_user
    @current_user
  end

  private

  def authenticate_user_from_token!
    if ensure_params_exist
      user = User.where(email: params[:authentication][:user_email]).first

      if user && Devise.secure_compare(user.authentication_token, params[:authentication][:authentication_token])
        @current_user = user
        return
      else
        invalid_login_attempt("Your Authentication failed.  Your Email and Authentication Token did not match.  Login/Reauthenticate to get a proper Authentication Token.")
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
    end

    if params[:authentication][key]
      return true 
    else
      invalid_login_attempt(message)
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
