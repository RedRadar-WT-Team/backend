class Api::V1::RepresentativesController < ApplicationController
  def index
    require 'pry'; binding.pry
    if params[:db].present? && params[:db] == true
      # For db representatives 
    else
      representatives = RepresentativeGateway.fetch_queried_reps(params[:query])
      
      render json: RepresentativeSerializer.new(representatives)
    end
  end
    
  def show
    if params[:db].present? && params[:db] == true
      #For db representatives
    else
      representatives = RepresentativeGateway.fetch_queried_reps(params[:query])
      representative  = RepresentativePoro.find_by_id(params[:id], representatives)
  
      render json: RepresentativeSerializer.new(representative)
    end
  end
end