class Api::V1::UsersController < ApplicationController
  before_action :set_current_user, only: [:update]

  def create
    user = User.new(user_params)

    if user.save
      render json: { message: 'Account created successfully!', user: user }, status: :created
    else
      render json: { errors: user.errors.full_messages.join(", ") }, status: :unprocessable_entity
    end
  end

  def show
    if logged_in?
      @user = current_user
      render json: @user
    else
      render json: { error: "You must be logged in to access your profile." }, status: :unauthorized
    end
  end

  def update
    # Ensure the user is logged in
    if !logged_in?
      render json: { error: "You must be logged in to update your profile." }, status: :unauthorized
      return
    end

    # Check if the logged-in user is trying to update their own profile
    if @current_user.id != params[:id].to_i
      render json: { error: "You are not authorized to update this profile." }, status: :forbidden
      return
    end

    # Update the user if authorized
    if @current_user.update(user_params)
      render json: { message: 'Account updated successfully!', data: @current_user }, status: :ok
    else
      render json: { errors: @current_user.errors.full_messages.join(", ") }, status: :unprocessable_entity
    end
  end

  private

  # Ensure the correct user is set based on the session and params
  def set_current_user
    # This assumes you're using the email in session to identify the current user
    @current_user = User.find_by(email: session[:current_user_email])
    if @current_user.nil?
      render json: { error: "You must be logged in to update your profile." }, status: :unauthorized
      return
    end
  end

  def user_params
    params.require(:user).permit(:email, :state, :zip)
  end
end
