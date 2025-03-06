class RepresentativePoro

  attr_reader :id,
              :name,
              :phone,
              :photo_url,
              :party,
              :state,
              :district,
              :area,
              :reason,
              :location

  def initialize(rep, district, query)
    @id = rep[:id]
    @name = rep[:name]
    @phone = rep[:phone]
    @photo_url = rep[:photoURL]
    @party = rep[:party]
    @state = rep[:state]
    @district = district
    @area = rep[:area]
    @reason = rep[:reason]
    @location = query
  end

  def self.find_by_id(target, reps)
    return reps.find { |rep|
      rep.id == target
    } 
  end
end