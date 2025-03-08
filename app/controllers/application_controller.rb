class ApplicationController < ActionController::Base
  # from Action Controller Overview Rails docs, #6: Session
  def current_user
    # Check if there's a current user ID stored in the session, and if so, find the user by email
    @_current_user ||= session[:current_user_id] && 
      User.find_by(id: session[:current_user_id])
  end

  def logged_in?
    current_user.present?
  end

  def logout
    session[:current_user_id] = nil
    @_current_user = nil # Clear the cached current user
  end
end
