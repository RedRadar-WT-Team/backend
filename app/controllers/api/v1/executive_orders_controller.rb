class Api::V1::ExecutiveOrdersController < ApplicationController
  def index
    begin
      executive_orders = ExecutiveOrderGateway.current_administration_eos
      render json: ExecutiveOrderSerializer.new(executive_orders)
    rescue => e 
      render json: { error: e.message }, status: 500
    end
  end

  def recent
    begin
      executive_orders = ExecutiveOrderGateway.five_most_recent 
      render json: ExecutiveOrderSerializer.new(executive_orders)
    rescue => e 
      render json: { error: e.message }, status: 500
    end
  end

  def show 
    begin
      document_number = params[:id]
      executive_order = ExecutiveOrderDetailGateway.find_specific_eo(document_number)
      if executive_order.nil?
        render json: { error: "Executive order not found" }, status: 404
      else
        render json: ExecutiveOrderSerializer.new(executive_order)
      end
    end
  end

  def create
    begin
      executive_order = ExecutiveOrder.new(executive_order_params)
    if executive_order.save
      render json: ExecutiveOrderSerializer.new(executive_order), status: :created
    else
      render json: { errors: executive_order.errors.full_messages }, status: 422
    end
    rescue => e
      render json: { error: e.message }, status: 500
    end
  end

  private

  def executive_order_params
    params.permit(:title, :html_url, :executive_order_number, :publication_date)
  end
end 