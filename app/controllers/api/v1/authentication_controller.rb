class Api::V1::AuthenticationController < Api::V1::ApplicationController
  skip_before_filter :authenticate_user_from_token!, only: [:create]
  
  respond_to :json

  def create
    login = request.headers

    if login
      email = login["X-User-Email"]
      password = login["X-User-Password"]
      auth_token = login["X-Provider-Auth-Token"]
      token_secret = login["X-Provider-Token-Secret"]
      provider = login["X-Provider-Name"]
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

  
  def authenticate_by_twitter(token, token_secret)
    access_token = prepare_twitter_access_token(token, token_secret)
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

      authProvider = AuthProvider.find_or_initialize_by(user_uid: user_id, name: "twitter")

      if authProvider && authProvider.persisted? && authProvider.user?
        user = authProvider.user
      else
        authProvider.attributes = {
          name: "twitter",
          user_uid: user_id,
          user_name: name,
          user_screen_name: user_screen_name,
          user_profile_image_url: profile_image_url
        }
        authProvider.save

        render json: { success: false, requires_signup: true, message: "You must signup first an account first."}, status: 401
        return
      end
    else
      return false
    end

    return user
  end

end