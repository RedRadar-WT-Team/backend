class Api::V1::RepresentativesUsersController < ApplicationController
  # before_action :set_gateway

  def create
    allowed = api_params()

    query = allowed[:query]
    representative_id = allowed[:id]
    user_id = allowed[:user_id]

    representatives = FetchRepresentativesService.call(allowed[:query])
    binding.pry
    selected_representative = RepresentativePoro.find_by_id(representative_id, representatives)

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

    begin
      RepresentativeUser.create!(
        user_id: user_id, 
        representative_id: representative.id
      )

      render json: { success: true, representative: representative}, status: :created 
    rescue
      render json: { success: true, message: "Already saved", representative: representative }, status: :ok
    end
  rescue 
    render json: { success: false, error: "NOOOOOOO" }, status: :bad_request
  end

  private
  
  def api_params
      params.permit(:id, :query, :user_id)
  end

  def set_gateway
    @rep_gateway = RepresentativeGateway.new
    binding.pry
  end

end



  #   allowed = api_params()
  #   # http://localhost:3000/api/v1/representatives?query=${location}&id=${id}&user_id=${currentUser}`



  #   representative_id = params[:id]

  #   # representative_id = Representative.find(params[:representative_id]) if params[:representative_id].present?

  #   # else
  #   #   representative_params = params.require(:representative).permit(:name, :phone, :photo_url, :party, :state, :district, :area, :reason)
    
  #   # representative = Representative.find_or_create_by(
  #   #   name: representative_params[:name],
  #   #   state: representative_params[:state]
  #   # ) do |rep|
  #   #   rep.assign_attributes(representative_params)
  #   # end
    
  #     representative_poro = RepresentativePoro.find_by_id(allowed[:id], representatives)
  #     render json: RepresentativeApiSerializer.new(representative)
  

  #   if representative.persisted?
  #     begin
  #       RepresentativesUser.create!(
  #         user_id: current_user.id,
  #         representative_id: representative.id
  #       )

  #       render json: { success: true, representative: representative }, status: :create
  #     rescue ActiveRecord::RecordNotUnique

  #       render json:     {
  #         success: true,
  #         message: "Representative already saved",
  #         representative: representative
  #       }, status: :ok
  #     end
  #   else
  #     render json: {
  #       success: false,
  #       errors: representative.errors.full_messages
  #     }, status: :unprocessable_entity
  #   end

  #   rescue ActionController::ParameterMissing => e
  #     render json: { success: false, error: e.message }, status: :bad_request
  # end

  # private

  # def api_params
  #   params.permit(:db, :query, :id)
  # end

  # def representatives_users_params
  #   params.permit(:user_id, :representative_id)
  # end

  # # def representatives_users_params
  # #   params.permit(:name, :phone, :photo_url, :party, :state, :district, :area, :reason)
  # # end
