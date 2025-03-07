class Api::V1::LoginController < ApplicationController
  # "Create" a login, aka "log the user in"
  def create
    user = User.find_by(email: params[:email]) # Look for the user by email

    if user
      # Store the user's email in the session
      session[:current_user_email] = user.email
      redirect_to user_profile_path # Redirect to a page where user can view their profile
    else
      # If user is not found, show an error
      render json: { error: 'User not found' }, status: :not_found
    end
  end

  def destroy
    # Clear the session to log the user out
    session.delete(:current_user_email)
    render json: { message: 'Logged out successfully.' }, status: :ok
  end
end
