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
    @user = User.find_by(id: params[:id]) # Ensure it's looking for `id`
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
  
  def by_email
    email = request.headers['X-User-Email']  # Get email from custom header

    @user = User.find_by(email: email)

    if @user
      render json: @user, status: :ok
    else
      render json: { error: 'User not found' }, status: :not_found
    end
  end

  private

  def set_user
    @user = User.find_by(id: params[:id])
    render json: { error: 'User not found' }, status: :not_found if @user.nil?
    return
  end

  def user_params
    params.require(:user).permit(:email, :state, :zip)
  end
end
 