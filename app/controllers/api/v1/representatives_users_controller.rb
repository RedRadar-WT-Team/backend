class Api::V1::RepresentativesUsersController < ApplicationController
  # before_action :set_gateway

  def create
    allowed = api_params()

    representatives = FetchRepresentativesService.call(allowed[:query])

    selected_representative = RepresentativePoro.find_by_id(allowed[:id], representatives)

    representative = Representative.find_or_create_by(
      name: selected_representative.name,
      state: selected_representative.state,
    ) do |rep|
      rep.phone = selected_representative.phone
      rep.photo_url = selected_representative.photo_url
      rep.party = selected_representative.party
      rep.district = selected_representative.district
      rep.area = selected_representative.area
      rep.reason = selected_representative.reason
    end

    representatives_user = RepresentativesUser.find_or_initialize_by(
      user_id: session[:user_id], 
      representative_id: representative.id
    )

    if representatives_user.save 
      render json: RepresentativeUserSerializer.new(representatives_user, include: [:user, :representative]), status: :created
    else
      head 500
    end
  end

  def destroy
    # representatives_user = RepresentativesUser.find(params[:id])
    rep_user = RepresentativesUser.find_by(user_id: params[:user_id], representative_id: params[:representative_id])
    
    if rep_user
      rep_user.delete
      render json: { message: "Successfully unsaved!"}, status: :no_content
    else
      render json: { error: "Record not found" }, status: :not_found
    end
  end

  private
  
  def api_params
      params.permit(:id, :query, :user_id)
  end

  def set_gateway
    @rep_gateway = RepresentativeGateway.new
  end

end
