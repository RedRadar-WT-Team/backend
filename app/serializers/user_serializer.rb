class UserSerializer
  include JSONAPI::Serializer

  attributes  :id,
              :email,
              :state,
              :zip

  # has_many :representatives, serializer: RepresentativeSerializer
  # has_many :executive_orders, serializer: ExecutiveOrderSerializer
  # has_many :representatives_users, serializer: RepresentativeUserSerializer
end 