# frozen_string_literal: true

require 'sphinx_helper'

RSpec.describe SearchController, type: :controller, sphinx: true do
  describe 'GET #index' do
    context 'with query' do
      let(:search_params) { { query: 'body', scope: 'Question' } }
      let!(:questions) { create_list(:question, 2) }

      it 'render index' do
        get :index, params: { search: search_params }, format: :js

        expect(response).to render_template :index
      end

      it 'populates an array' do
        get :index, params: { search: search_params }, format: :js

        expect(assigns(:search).results).to match_array(questions)
      end

      it 'assigns @search' do
        get :index, params: { search: search_params }, format: :js

        expect(assigns(:search)).to be_a Search
      end
    end

    context 'without query' do
      it 'render index' do
        get :index, format: :js

        expect(response).to render_template :index
      end

      it 'call Search.new' do
        expect(Search).to receive(:new)

        get :index, format: :js
      end

      it 'assigns @search' do
        get :index, format: :js

        expect(assigns(:search)).to be_a Search
      end
    end
  end
end
