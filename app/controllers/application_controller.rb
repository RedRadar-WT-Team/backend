class ApplicationController < ActionController::API
  # from Action Controller Overview Rails docs, #6: Session

  def current_user
    # Check if there's a current user ID stored in the session, and if so, find the user by email
    @_current_user ||= session[:current_user_email] && User.find_by(email: session[:current_user_email])
  end

  # This method is useful for checking if a user is logged in or not
  def logged_in?
    current_user.present?
  end
end
