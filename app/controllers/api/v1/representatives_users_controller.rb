class Api::V1::RepresentativesUsersController < ApplicationController
  def create

    query = params[:query]
    representative_id = params[:id]
    user_id = params[:user_id]

    representatives = RepresentativeGateway.fetch_queried_reps(allowed[:query])

    selected_representative = RepresentativePoro.find_by_id(representative_id, representatives)

    representative = Representative.find_or_create_by(
      name: selected_representative.name,
      state: selected_representative.state,
    ) do |rep|
      rep.phone = representative_poro.phone
      rep.photo_url = representative_poro.photo_url
      rep.party = representative_poro.party
      rep.district = representative_poro.district
      rep.area = representative_poro.area
      rep.reason = representative_poro.reason
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
