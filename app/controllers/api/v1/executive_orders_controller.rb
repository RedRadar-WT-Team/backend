class Api::V1::ExecutiveOrdersController < ApplicationController

  def index
    executive_orders = ExecutiveOrderGateway.five_most_recent 
    render json: executive_orders
  end
end 