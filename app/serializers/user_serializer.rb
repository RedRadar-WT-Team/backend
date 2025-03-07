class UserSerializer
  include JSONAPI::Serializer

  attributes  :id,
              :email,
              :state,
              :zip
end 