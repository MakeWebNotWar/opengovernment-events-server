class Api::V1::ApplicationController < ApplicationController
  include ApplicationHelper
  before_filter :authenticate_user_from_token!

end