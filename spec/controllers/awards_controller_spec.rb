# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AwardsController, type: :controller do
  let(:user) { create(:user) }
  let(:awards) { create_list(:award, 3, user: user) }

  describe 'GET #index' do
    before do
      sign_in(user)
      get :index
    end

    it 'populates an array of user awards' do
      expect(assigns(:awards)).to match_array(awards)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end
end
