class Api::V1::ExecutiveOrdersUsersController < ApplicationController
  # before_action :set_user, only: [:create, :index, :destroy]

  def create
    executive_order_number = params[:executive_order_number]
    
    user = User.find(session[:user_id])

    executive_order = ExecutiveOrder.find_or_create_from_gateway(executive_order_number: executive_order_number)

    existing_association = ExecutiveOrdersUser.find_by(user: @user, executive_order: executive_order)

    if existing_association
      render json: { message: "Executive order already saved." }, status: :ok
      return
    end
    
    executive_order_user = ExecutiveOrdersUser.new(user: user, executive_order: executive_order)

    render json: { message: "Successfully saved." }, status: :created
  end

  def index
    begin
      user_id = params[:user_id]
      user = User.find(user_id)

      executive_orders = user.executive_orders 

      render json: ExecutiveOrderSerializer.new(executive_orders)
    rescue => e 
        render json: { error: e.message }, status: 500
    end
  end

  def destroy
    executive_order_user  = ExecutiveOrdersUser.find(params[:id])

    if executive_order_user
      executive_order_user.destroy
      render json: { message: "Unsave Successful" }
    else
      render json: { error: "Record not found"}
    end
  end

  private 

  def executive_orders_users_params
    params.permit(:user_id, :executive_order_id)
  end
  
  # def set_user
  #   @user = User.find_by(id: session[:user_id])

  #   if @user.nil?
  #     render json: { error: 'User not found' }, status: :not_found
  #   end
  # end

end