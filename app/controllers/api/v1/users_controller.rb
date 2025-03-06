class Api::V1::UsersController < ApplicationController
  before_action :set_current_user
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
    else
      flash[:alert] = "You must be logged in to access your profile."
      redirect_to login_path
    end
  end

  def update
    if @current_user.update(user_params)
      render json: { message: 'Account updated successfully!', data: @current_user }, status: :ok
    else
      render json: { errors: user.errors.full_messages.join(", ") }, status: :unprocessable_entity
    end
  end

  private 
  def set_current_user
    @current_user = User.find_by(id: params[:id])
    if !@current_user
      render json: { error: 'User not found' }, status: :not_found
    end
  end

  def user_params
    params.require(:user).permit(:email, :state, :zip)
  end
end
