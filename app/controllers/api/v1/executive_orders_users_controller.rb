class Api::V1::ExecutiveOrdersUsersController < ApplicationController
  def create
    executive_order_number = params[:executive_order_number]

    user = User.find(session[:user_id])
    executive_order = ExecutiveOrder.find_or_create_from_gateway(executive_order_number: executive_order_number)
    
    executive_order_user = ExecutiveOrdersUser.create!(user: user, executive_order: executive_order)

    render json: executive_order_user, status: :created
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
end