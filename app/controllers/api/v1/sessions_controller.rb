# app/controllers/api/v1/sessions_controller.rb

class Api::V1::SessionsController < ApplicationController

  def create 
    @user = User.find_by(email: params[:email])

    if @user
      session[:user_id] = @user.id
      render json: { message: 'Logged in successfully' }, status: :created
    else
      session[:user_id] = nil
      render json: { error: 'User not found' }, status: :not_found
    end
  end

  def destroy 
    session[:user_id] = nil
    render json: { message: 'Logged out successfully.' }, status: :ok
  end
end
