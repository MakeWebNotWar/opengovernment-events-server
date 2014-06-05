class Api::V1::SignupController < Api::V1::ApplicationController
  skip_before_filter :authenticate_user_from_token!
  
  respond_to :json

  def create
    header = request.headers
    if header["X-Provider-Auth-Token"] && header["X-Provider-Token-Secret"] && header["X-Provider-Name"] === "twitter"
      token = header["X-Provider-Auth-Token"]
      token_secret = header["X-Provider-Token-Secret"]
      access_token = prepare_twitter_access_token(token, token_secret)
      response = access_token.request(:get, "https://api.twitter.com/1.1/account/verify_credentials.json")
      if response.code === "200"
        user = nil
        body = JSON.parse(response.body)
        user_id = body["id"]
        user_screen_name = body["screen_name"]
        name = body["name"].split()
        firstname = name.first if name.length >= 1
        lastname = name.last if name.length >= 2
        followers_count = body["followers_count"]
        profile_image_url = body["profile_image_url_https"]

        authProvider = AuthProvider.find_or_initialize_by(user_uid: user_id, name: "twitter")

        if authProvider.persisted? && authProvider.user?
          authenticate_user!(authProvider.user)

        else authProvider && !authProvider.user?
          

          authProvider.attributes = {
            name: "twitter",
            user_uid: user_id,
            user_name: name,
            user_screen_name: user_screen_name,
            user_profile_image_url: profile_image_url
          }

          if request.headers['X-Authentication-Token']
            user = User.find_for_database_authentication(authentication_token: request.headers['X-Authentication-Token'], email: request.headers['X-User-Email'])
          end

          if !user  
            user = User.new
            user.attributes = {
              firstname: firstname,
              lastname: lastname,
            }
            user.auth_providers << authProvider
            user.save
          end

          authProvider.save

          render json:{
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
          }, status: 200

        end
      else
        invalid_login_attempt('Your twitter authentication failed.  Try again.')
      end

    elsif params[:signup][:email] && params[:signup][:password] && params[:signup][:password_confirmation]
      user = User.new(signup_params)
      if user.save
        authenticate_user!(user)
      else
        warden.custom_failure!
        render :json=> user.errors, :status=>422
      end
    else
      invalid_login_attempt("You are missing your signup details.  Please try again.")
    end
  end

  private

  def signup_params
    params.require(:signup).permit(:firstname, :lastname, :email, :password, :password_confirmation)
  end
end