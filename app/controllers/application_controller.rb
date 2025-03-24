class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session, if: -> { request.format.json? }

  # from Action Controller Overview Rails docs, #6: Session
  def current_user
    # Check if there's a current user ID stored in the session, and if so, find the user by email
    @_current_user ||= session[:user_id] && 
      User.find_by(id: session[:user_id])
  end

  def logged_in?
    current_user.present?
  end

  def logout
    session[:current_user_id] = nil
    @_current_user = nil # Clear the cached current user
  end
end
