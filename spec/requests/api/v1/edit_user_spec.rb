# bundle exec rspec spec/requests/api/v1/edit_user_spec.rb

require './rails_helper'

RSpec.descripb 'PATCH /api/v1/users', type: :request do 
  let(:user) { create!(:user) }
end