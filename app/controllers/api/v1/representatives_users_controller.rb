class Api::V1::RepresentativesUsersController < ApplicationController
  def create

    representative_params = params.require(:representative).permit(:name, :phone, :photo_url, :party, :state, :district, :area, :reason)
    
    # representative = Representative.find_or_create_by(
    #   name: representative_params[:name],
    #   state: representative_params[:state]
    # ) do |rep|
    #   rep.assign_attributes(representative_params)
    # end
    
    representatives = RepresentativeGateway.fetch_queried_reps(allowed[:query])
    representative = RepresentativePoro.find_by_id(allowed[:id], representatives)
    render json: RepresentativeApiSerializer.new(representative)

    if representative.persisted?

      begin
        RepresentativesUser.create!(
          user_id: current_user.id,
          representative_id: representative.id
        )

        render json: { success: true, representative: representative }, status: :create
      rescue ActiveRecord::RecordNotUnique

        render json: {
          success: true,
          message: "Representative already saved",
          representative: representative
        }, status: :ok
      end
    else
      render json: {
        success: false,
        errors: representative.errors.full_messages
      }, status: :unprocessable_entity
    end

    rescue ActionController::ParameterMissing => e
      render json: { success: false, error: e.message }, status: :bad_request
    end
  end
