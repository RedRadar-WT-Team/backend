class Api::V1::ExecutiveOrdersController < ApplicationController

  # def index
  #   executive_orders = ExecutiveOrderGateway.five_most_recent 
  #   render json: ExecutiveOrderSerializer.new(executive_orders)
  # end

  def index
    executive_orders = ExecutiveOrderGateway.current_administration_eos
    render json: ExecutiveOrderSerializer.new(executive_orders)
  end

  def recent
    executive_orders = ExecutiveOrderGateway.five_most_recent 
    render json: ExecutiveOrderSerializer.new(executive_orders)
  end



end 