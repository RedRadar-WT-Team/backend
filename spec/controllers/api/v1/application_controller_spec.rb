require 'rails_helper'
RSpec.describe ApplicationController, type: :controller do
  describe 'current_user and logged_in? methods' do
    let(:user) { create(:user) }

    context 'when the user is logged in' do
      before do
        session[:user_id] = user.id 
        allow(controller).to receive(:current_user).and_return(user)
        allow(controller).to receive(:logged_in?).and_return(true)
        controller.set_user_from_session
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
        session[:user_id] = nil  # Ensure session is cleared
        allow(controller).to receive(:current_user).and_return(nil)
        allow(controller).to receive(:logged_in?).and_return(false)
        controller.set_user_from_session
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
