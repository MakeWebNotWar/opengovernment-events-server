module ApplicationHelper
  require 'reverse_markdown'

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
    @current_user ||= User.where(authentication_token: request.headers['X-Authentication-Token']).first
  end

  def authenticate_user!(user)
    user.ensure_authentication_token
    render json: {
      success: true,
      message: "Authenticated",
      requires_signup: !user.email?,
      user_id: user.id,
      user_email: user.email,
      user_firstname: user.firstname,
      user_lastname: user.lastname,
      authentication_token: user.authentication_token,
      user_confirmed: user.confirmed,
      user_gravatarID: user.gravatarID,
      admin: user.admin
    }
    return
  end

  private

  def authenticate_user_from_token!
    if ensure_params_exist
      user = User.find_for_database_authentication(authentication_token: params[:authentication][:authentication_token])
      if user
        @current_user = user
        return
      else
        invalid_login_attempt("Your Authentication failed.  Your Authentication Token is invalid.  Login/Reauthenticate to get a proper Authentication Token.")
      end
    else
      return false
    end
  end

  def ensure_params_exist
    if ensure_authentication_token
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

    logger.debug "\n\rheader: #{request.headers[header_key]}\n\r"

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

  def prepare_twitter_access_token(oauth_token, oauth_token_secret)
    consumer = OAuth::Consumer.new(ENV["Twitter_API_Key"], ENV["Twitter_API_Secret"], {
        site: 'https://api.twitter.com',
        scheme: :header
      })

    token_hash = {
      :oauth_token => oauth_token,
      :oauth_token_secret => oauth_token_secret
    }

    access_token = OAuth::AccessToken.from_hash(consumer, token_hash)
    return access_token
  end

  def reverse_markdown(html)
    ReverseMarkdown.convert(html, unknown_tags: :ignore)
  end

end
