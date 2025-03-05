class Api::V1::ExecutiveOrdersUsersController < ApplicationController
  def create
    executive_order_number = params[:id] # might change to :document_number

    executive_order = ExecutiveOrder.find_by(key: executive_order_number)
    
    if executive_order === nil 
     found_executive_order = ExecutiveOrderDetailGateway.find_specific_eo(executive_order_number)
     ExecutiveOrder.create!(found_executive_order)
    end

    executive_order_user
  end

  private 

  def executive_order_params
    params.permit(:title, :html_url, :executive_order_number, :publication_date)
  end
end