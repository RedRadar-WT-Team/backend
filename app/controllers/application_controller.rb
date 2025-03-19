class ApplicationController < ActionController::API
  # This will automatically manage session cookies (Rails does it for you by default)
  before_action :set_user_from_session

  public

  def set_user_from_session
    @current_user = User.find_by(id: session[:user_id])
  end

  def current_user
    @current_user
  end

  def logged_in?
    current_user.present?
  end
end
