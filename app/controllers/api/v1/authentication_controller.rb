class Api::V1::AuthenticationController < Api::V1::ApplicationController
  skip_before_filter :authenticate_user_from_token!, only: [:create]
  before_filter :ensure_user_email
  before_filter :ensure_user_password, except: [:destroy]
  
  respond_to :json

  def create
    login = params[:authentication]
    user = User.find_for_database_authentication(email: login[:user_email])

    if user && user.valid_password?(login[:user_password])
      authenticate_user!(user)
    else
      invalid_login_attempt("Your email or password is incorrect")
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
      user_id: user.id,
      user_email: user.email,
      user_firstname: user.firstname,
      user_lastname: user.lastname,
      authentication_token: user.authentication_token,
      user_gravatarID: user.gravatarID
    }
    return
  end
end