class FetchRepresentativesService
  def self.call(query) 
    RepresentativeGateway.new.fetch_queried_reps(query)
  end
end