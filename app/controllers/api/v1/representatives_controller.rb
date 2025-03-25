class Api::V1::RepresentativesController < ApplicationController
  def index
    allowed = api_params()

    if allowed[:db].present? && allowed[:db] == "true"
      representatives = Representative.all
      render json: RepresentativeSerializer.new(representatives)
    else
      representatives = RepresentativeGateway.fetch_queried_reps(allowed[:query])
      render json: RepresentativeApiSerializer.new(representatives)
    end
  end

  def show
    allowed = api_params()

    if allowed[:db].present? && allowed[:db] == "true"
      representative = Representative.find_by(id: allowed[:id])
      
      if representative
        render json: RepresentativeSerializer.new(representative)
      else
        render json: { error: "Representative not found" }, status: :not_found
      end
    elsif allowed[:db].present? && allowed[:db] == "false"
      representatives = RepresentativeGateway.fetch_queried_reps(allowed[:query])
      representative = RepresentativePoro.find_by_id(allowed[:id], representatives)
      render json: RepresentativeApiSerializer.new(representative)

    else
      render json: {error: "404 Not Found"}, status: :not_found
    end
  end

  private

  def api_params
    params.permit(:db, :query, :id)
  end
end
