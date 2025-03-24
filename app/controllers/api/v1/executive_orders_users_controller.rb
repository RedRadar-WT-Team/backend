class Api::V1::ExecutiveOrdersUsersController < ApplicationController
  def create
    executive_order_number = params[:executive_order_number]

    user = User.find(session[:user_id])

    executive_order = ExecutiveOrder.find_or_create_from_gateway(executive_order_number: executive_order_number)

    executive_order_user = ExecutiveOrdersUser.create!(user: user, executive_order: executive_order)

    render json: executive_order_user, status: :created
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