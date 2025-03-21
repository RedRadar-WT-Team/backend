class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session, if: -> { request.format.json? }

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

  # def authenticate_user! # helper method to protect certain app actions
  #   unless logged_in?
  #     logger.debug "User not logged in. Redirecting to login..."
  #     render json: { error: 'Please log in first.' }, status: :unauthorized
  #   else
  #     logger.debug "User logged in: #{current_user.email}"
  #   end
  #   # unless logged_in?
  #   #   render json: { error: 'Please log in first.' }, status: :unauthorized
  #   # end
  # end
end
