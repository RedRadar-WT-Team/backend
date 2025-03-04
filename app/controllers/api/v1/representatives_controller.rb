class Api::V1::RepresentativesController < ApplicationController
  def index
    if params[:db].present? && params[:db] == true
      # For db representatives 
    else
      representatives = RepresentativeGateway.fetch_queried_reps(params[:query])
    end

    render json: RepresentativeSerializer.new(representatives)
  end
end