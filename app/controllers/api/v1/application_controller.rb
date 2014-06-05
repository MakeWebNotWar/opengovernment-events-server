class Api::V1::ApplicationController < ApplicationController
  include ApplicationHelper
  before_filter :authenticate_user_from_token!
  skip_before_filter :verify_authenticity_token
  # after_filter :set_csrf_header, only: [:new, :create]

  protected

  def set_csrf_header
     response.headers['X-CSRF-Token'] = form_authenticity_token
  end
  
end