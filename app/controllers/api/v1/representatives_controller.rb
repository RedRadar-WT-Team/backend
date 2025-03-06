class Api::V1::RepresentativesController < ApplicationController
  def index
    require 'pry'; binding.pry
    if params[:db].present? && params[:db] == "true"
      representatives = Representative.all
    else
      representatives = RepresentativeGateway.fetch_queried_reps(params[:query])
      
      render json: RepresentativeSerializer.new(representatives)
    end
  end

  def show
    representative = Representative.find_by(id: params[:id])
    
    if representative
      render json: RepresentativeSerializer.new(representative)
    else
      render json: { error: "Representative not found" }, status: :not_found
    end
  end

  def create
    representative = Representative.new(representative_params)

    if representative.save
      render json: RepresentativeSerializer.new(representative), status: :created
    else
      render json: { errors: representative.errors[:name].first }, status: :unprocessable_entity
    end
  end

  private

  def representative_params
    params.require(:representative).permit(:name, :phone, :photo_url, :party, :state, :district, :area, :reason)
  end
end
