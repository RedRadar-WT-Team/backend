class RepresentativePORO

  attr_reader :id,
              :name,
              :phone,
              :photo_url,
              :party,
              :state,
              :district,
              :area,
              :reason

  def initialize(rep, district)
    @id = rep[:id]
    @name = rep[:name]
    @phone = rep[:phone]
    @photo_url = rep[:photoURL]
    @party = rep[:party]
    @state = rep[:state]
    @district = district
    @area = rep[:area]
    @reason = rep[:reason]
  end
end