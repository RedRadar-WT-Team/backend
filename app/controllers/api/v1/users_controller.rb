class Api::V1::UsersController < ApplicationController
  def create
    user = User.new(user_params)

    if user.save
      render json: { message: 'Account created successfully!', user: user }, status: :created
    else
      render json: { errors: user.errors.full_messages.join(", ") }, status: :unprocessable_entity
    end
  end

  private 

  def user_params
    params.require(:user).permit(:email, :state, :zip)
  end
end
