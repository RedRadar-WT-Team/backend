class Api::V1::ExecutiveOrdersController < ApplicationController
  def index
    executive_orders = ExecutiveOrderGateway.current_administration_eos
    render json: ExecutiveOrderSerializer.new(executive_orders)
  end

  def recent
    executive_orders = ExecutiveOrderGateway.five_most_recent 
    render json: ExecutiveOrderSerializer.new(executive_orders)
  end

  def show 
    document_number = params[:id]
    executive_order = ExecutiveOrderDetailGateway.find_specific_eo(document_number)
    render json: ExecutiveOrderSerializer.new(executive_order)
  end

  def create
    executive_order = ExecutiveOrder.new(executive_order_params)
    
  end

  private

  def executive_order_params
    params.permit(:title, :html_url, :executive_order_number, :publication_date)
  end
end 