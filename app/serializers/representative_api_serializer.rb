class RepresentativeApiSerializer
  include JSONAPI::Serializer
  
  attributes  :id,
              :name, 
              :phone, 
              :photo_url, 
              :party, 
              :state, 
              :district, 
              :area, 
              :reason,
              :location
end 