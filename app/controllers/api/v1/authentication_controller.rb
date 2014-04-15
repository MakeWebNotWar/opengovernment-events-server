class Api::V1::AuthenticationController < Api::V1::ApplicationController
  skip_before_filter :authenticate_user_from_token!, only: [:create]
  before_filter :ensure_user_password, only: [:create]
  before_filter :ensure_user_email, only: [:create]
  
  respond_to :json

  def create
    login = params[:authentication]
    user = User.find_for_database_authentication(email: login[:user_email])

    if user && user.valid_password?(login[:user_password])
      authenticate_user!(user)
    else
      invalid_login_attempt("Your email or password is incorrect", 401)
    end
  end

  def destroy
    login = params[:authentication]
    user = User.find_for_database_authentication(email: login[:user_email])
    
    if user
      user.authentication_token = nil
      if user.save
        authenticate_user!(user)
      else
        invalid_login_attempt("Could not destroy your Authentication Token.", 401)
      end
    else
      invalid_login_attempt("Your email or authentication token is incorrect", 401)
    end
  end

  protected

  def authenticate_user!(user)
    user.ensure_authentication_token
    render json: {
      success: true,
      id: user.id,
      email: user.email,
      authentication_token: user.authentication_token
    }
    return
  end
end