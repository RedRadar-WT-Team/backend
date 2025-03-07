class Api::V1::UsersController < ApplicationController

  def create # create new user
    user = User.new(user_params)

    if user.save
      render json: { message: 'Account created successfully!', user: user }, status: :created
    else
      render json: { errors: user.errors.full_messages.join(", ") }, status: :unprocessable_entity
    end
  end

  def show # fetch user by email and return their profile data
    user = User.find_by(email: params[:email])
    render json: UserSerializer.new(user)
  end

  def update # user that is logged in can update their information
    if @current_user.update(user_params)
      render json: { message: 'Account updated successfully!', data: @current_user }, status: :ok
    else
      render json: { error: @current_user.errors.full_messages.join(", ") }, status: :unprocessable_entity
    end
  end

  def status #check if user is logged in (by checking the session) and return their details
    if session[:current_user_email]
      @user = User.find_by(email: session[:current_user_email]) # Find the user from the session
      render json: { logged_in: true, user: @user.email  }
    else
      render json: { logged_in: false }
    end
  end

  private

  # def ensure_logged_in
  #   unless logged_in?
  #     render json: { error: "You must be logged in to access your profile." }, status: :unauthorized
  #     return
  #   end
  # end

  def set_current_user
    @current_user = User.find_by(id: params[:id])
    if @current_user.nil?
      render json: { error: "User not found" }, status: :not_found
      return
    end
  end

  def user_params
    params.require(:user).permit(:email, :state, :zip)
  end
end
 