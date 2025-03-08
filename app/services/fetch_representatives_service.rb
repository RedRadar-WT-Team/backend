class FetchRepresentativesService
  def self.call(query) 
    RepresentativeGateway.fetch_queried_reps(query)
  end
end