class Api::V1::RepresentativesUsersController < ApplicationController
  # before_action :set_gateway

  def index
    begin 
      user_id = params[:user_id]
      user = User.find(user_id)

      representatives = user.representatives 

      render json: RepresentativeSerializer.new(representatives) 
      
    rescue => e 
      render json: { error: e.message }, status: 500
    end
  end

  def create
    allowed = api_params()

    representatives = FetchRepresentativesService.call(allowed[:query])

    user = User.find(session[:user_id])

    selected_representative = RepresentativePoro.find_by_id(allowed[:id], representatives)

    representative = Representative.find_or_create_by!(
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
      
      existing_association = RepresentativesUser.find_by(
        user: user, 
        representative: representative 
        )
        
        if existing_association
          render json: { message: "Representative already saved." }, status: :ok
          return
        end
        
        representative_user = RepresentativesUser.create!(user: user, representative: representative)
        binding.pry   

    render json: { message: "Successfully saved." }, status: :created
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
