class Api::V1::RepresentativesController < ApplicationController
  def index
    representatives = RepresentativeGateway.fetch_queried_reps(params[:query])
    render json: RepresentativeSerializer.new(representatives)
  end
end