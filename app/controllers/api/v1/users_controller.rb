class Api::V1::UsersController < ApplicationController
  before_action :set_current_user, only: [:update]
  before_action :authorize_user, only: [:update]
  before_action :ensure_logged_in, only: [:show, :update]

  def create
    user = User.new(user_params)

    if user.save
      render json: { message: 'Account created successfully!', user: user }, status: :created
    else
      render json: { errors: user.errors.full_messages.join(", ") }, status: :unprocessable_entity
    end
  end

  def show
    render json: @current_user
  end

  def update
    if @current_user.update(user_params)
      render json: { message: 'Account updated successfully!', data: @current_user }, status: :ok
    else
      render json: { error: @current_user.errors.full_messages.join(", ") }, status: :unprocessable_entity
    end
  end

  private

  def ensure_logged_in
    unless logged_in?
      render json: { error: "You must be logged in to access your profile." }, status: :unauthorized
      return
    end
  end

  def set_current_user
    @current_user = User.find_by(id: params[:id])
    if @current_user.nil?
      render json: { error: "User not found" }, status: :not_found
      return
    end
  end

  def authorize_user
    if @current_user.id != params[:id].to_i
      render json: { error: "You are not authorized to update this profile."}, status: :unauthorized
      return
    end
  end

  def user_params
    params.require(:user).permit(:email, :state, :zip)
  end
end
 