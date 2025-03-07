# bundle exec rspec spec/controllers/api/v1/application_controller_spec.rb

require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  describe 'current_user and logged_in? methods' do
    let(:user) { create(:user) }

    context 'when the user is logged in' do
      before do
        session[:current_user_email] = user.email
      end

      it 'returns the current user' do
        expect(controller.current_user).to eq(user)
      end

      it 'returns true for logged_in?' do
        expect(controller.logged_in?).to eq(true)
      end
    end

    context 'when the user is not logged in' do
      before do
        session[:current_user_email] = nil
      end

      it 'returns nil for current_user' do
        expect(controller.current_user).to eq(nil)
      end

      it 'returns false for logged_in?' do
        expect(controller.logged_in?).to eq(false)
      end
    end
  end
end
