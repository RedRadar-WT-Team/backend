class Api::V1::RepresentativesController < ApplicationController
  def index
    if params[:db].present? && params[:db] == true
      # For db representatives 
    else
      representatives = RepresentativeGateway.fetch_queried_reps(params[:query])
      if params[:id].present?
        representative = RepresentativePoro.find_by_id(params[:id], representatives)
        render json: RepresentativeSerializer.new(representative)
      else
        render json: RepresentativeSerializer.new(representatives)
      end
    end
  end
end