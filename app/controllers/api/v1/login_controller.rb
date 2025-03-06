class LoginsController < ApplicationController
  # "Create" a login, aka "log the user in"
  def create
    user = User.find_by(email: params[:email]) # Look for the user by email

    if user
      # Store the user's email in the session
      session[:current_user_email] = user.email
      redirect_to user_profile_path # Redirect to a page where user can view their profile
    else
      # If user is not found, show an error
      flash[:alert] = "User not found"
      redirect_to login_path # Redirect to login page
    end
  end

  def destroy
    # Remove the user's email from the session to log them out
    session[:current_user_email] = nil
    redirect_to login_path # Redirect back to the login page
  end
end
