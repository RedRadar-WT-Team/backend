class Api::V1::ExecutiveOrdersUsersController < ApplicationController
  def create
    executive_order_number = params[:id] # might change to :document_number

    user = User.find_by(:user_id)

    executive_order = ExecutiveOrder.find_by(executive_order_number)
    
    if executive_order === nil 
     found_executive_order = ExecutiveOrderDetailGateway.find_specific_eo(executive_order_number)
     ExecutiveOrder.create!(found_executive_order)
    end

    executive_order_user = Executive_Orders_Users.create!(executive_orders_users_params)

    render json: executive_order_user
  end

  private 

  def executive_orders_users_params
    params.permit(:id, :executive_order_number)
  end
end