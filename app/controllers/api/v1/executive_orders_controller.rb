class Api::V1::ExecutiveOrdersController < ApplicationController

  def index
    binding.pry
    # results = ExecutiveOrderGateway.five_most_recent(params[:query])....
    # connect to gateway 
    # gateway makes the request with the designated URL
    # passes those results
    
  end
end