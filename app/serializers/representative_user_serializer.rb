class RepresentativeUserSerializer
  include JSONAPI::Serializer
  
  attributes  :id,
              :user_id,
              :representative_id
  
  has_one :user, serializer: UserSerializer
  has_one :representative, serializer: RepresentativeSerializer
end

 