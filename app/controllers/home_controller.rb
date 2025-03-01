class HomeController < ApplicationController
  def index
    render json: { message: 'RepRadar homepage placeholder' }
  end
end
