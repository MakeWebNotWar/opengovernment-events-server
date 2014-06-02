class Api::V1::AuthenticationController < Api::V1::ApplicationController
  skip_before_filter :authenticate_user_from_token!, only: [:create]
  
  respond_to :json

  def create
    login = params[:authentication]

    if login
      email = login[:user_email] ||= nil
      password = login[:user_password] ||= nil
      auth_token = login[:provider_auth_token] ||= nil
      token_secret = login[:provider_token_secret] ||= nil
      provider = login[:provider_name] ||= nil
    end

    if email && password
      user = User.find_for_database_authentication(email: email)
      if user && user.valid_password?(password)
        authenticate_user!(user)
      else
        invalid_login_attempt("Email or Password are incorrect.")
      end
    elsif auth_token && token_secret && provider === "twitter"
      user = authenticate_by_twitter(auth_token, token_secret)
      if user
        authenticate_user!(user)
      else
        invalid_login_attempt("Your Twitter Auth Token and Secret are invalid and rejected by Twitter.")
      end
    else
        invalid_login_attempt("Credentials are incomplete. You are missing email/password or auth_token/secret.")
    end
  end

  def destroy
    login = params[:authentication]

    user = User.find_for_database_authentication(email: login[:user_email])
    
    if user === current_user
      user.authentication_token = nil
      if user.save
        authenticate_user!(user)
      else
        invalid_login_attempt("Could not destroy your Authentication Token.")
      end
    else
      invalid_login_attempt("Your email or authentication token is incorrect")
    end
  end

  protected

  def authenticate_user!(user)
    user.ensure_authentication_token
    render json: {
      success: true,
      message: "Authenticated",
      user_id: user.id,
      user_email: user.email,
      user_firstname: user.firstname,
      user_lastname: user.lastname,
      authentication_token: user.authentication_token,
      user_gravatarID: user.gravatarID,
      user_confirmed: user.confirmed
    }
    return
  end

  def authenticate_by_twitter(token, token_secret)
    access_token = prepare_access_token(token, token_secret)
    response = access_token.request(:get, "https://api.twitter.com/1.1/account/verify_credentials.json")

    if response.code === "200"
      body = JSON.parse(response.body)
      user_id = body["id"]
      user_screen_name = body["screen_name"]
      name = body["name"].split()
      firstname = name.first if name.length >= 1
      lastname = name.last if name.length >= 2
      followers_count = body["followers_count"]
      profile_image_url = body["profile_image_url_https"]

      authProvider_hash = {
        name: "twitter",
        user_uid: user_id,
        user_name: name,
        user_screen_name: user_screen_name,
        user_profile_image_url: profile_image_url
      }

      authProvider = AuthProvider.find_or_initialize_by(user_uid: user_id, name: "twitter")

      if authProvider.persisted? && authProvider.user?
        user = authProvider.user
      else
        authProvider.attributes = authProvider_hash
        authProvider.save

        generated_password = Devise.friendly_token.first(8)

        user = User.new
        user.attributes = {
          firstname: firstname,
          lastname: lastname,
          password: generated_password,
          password_confirmation: generated_password,
          email: "#{user_id}@example.com"
        }
        user.auth_providers << authProvider
        user.save
      end

      return user
    else
      return false
    end
  end

  def prepare_access_token(oauth_token, oauth_token_secret)
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

  def authenticate_user!(user)
    user.ensure_authentication_token
    render json: {
      success: true,
      message: "Authenticated",
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
end