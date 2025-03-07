# app/controllers/api/v1/sessions_controller.rb
# 
class Api::V1::SessionsController < ApplicationController

  def create #log user in by finding user via email and storing email in session
    @user = User.find_by(email: params[:email]) # Look for the user by email

    if @user
      # Store the user's email in the session
      session[:current_user_id] = @user.id
      render json: { message: 'Logged in successfully' }, status: :ok  # Return JSON response to frontend
    else
      # If user is not found, show an error
      render json: { error: 'User not found' }, status: :not_found
    end
  end

  def destroy # Clear the session to log the user out
    session[:current_user_id] = nil
    render json: { message: 'Logged out successfully.' }, status: :ok
  end
end
