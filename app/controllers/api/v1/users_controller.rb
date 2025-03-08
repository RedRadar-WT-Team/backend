class Api::V1::UsersController < ApplicationController
  before_action :set_user, only: [:update, :show]

  def create
    @user = User.new(user_params)

    if @user.save
      render json: { message: 'Account created successfully!', user: @user }, status: :created
    else
      render json: { errors: @user.errors.full_messages.join(", ") }, status: :unprocessable_entity
    end
  end
  
  def show
    if @user
      render json: UserSerializer.new(@user)
    else
      render json: { error: 'User not found' }, status: :not_found
    end
  end

  def update
    if @user.update(user_params)
      render json: { message: 'Account updated successfully!', data: @user }, status: :ok
    else
      render json: { error: @user.errors.full_messages.join(", ") }, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find_by(email: params[:email])

    if @user.nil?
      render json: { error: 'User not found' }, status: :not_found
    end
  end

  def user_params
    params.require(:user).permit(:email, :state, :zip)
  end
end
 