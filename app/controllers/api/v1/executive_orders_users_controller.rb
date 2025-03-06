class Api::V1::ExecutiveOrdersUsersController < ApplicationController
  def create
    executive_order_number = params[:executive_order_number] 

    user = User.find(params[:user_id])

    executive_order = ExecutiveOrder.find_by(executive_order_number: executive_order_number)
    
    if executive_order === nil 
     found_executive_order = ExecutiveOrderDetailGateway.find_specific_eo(executive_order_number)
     ExecutiveOrder.create!(found_executive_order)
    end

    executive_order_user = ExecutiveOrdersUser.create!(user: user, executive_order: executive_order)

    render json: executive_order_user, status: :created
  end

  def destroy
    executive_order_user  = ExecutiveOrdersUser.where(user_id: params[:user_id], executive_order_id: params[:executive_order_id])

    executive_order_user.delete_all

    render json: {message: "Unsave Successful"}, status: :no_content
  end

  private 

  def executive_orders_users_params
    params.permit(:user_id, :executive_order_id)
  end
end