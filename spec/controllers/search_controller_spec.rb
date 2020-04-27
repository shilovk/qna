# frozen_string_literal: true

require 'sphinx_helper'

RSpec.describe SearchController, type: :controller, sphinx: true do
  describe 'GET #index' do
    context 'with query' do
      let!(:questions) { create_list(:question, 2) }
      let(:search_params) { { query: 'body', scope: 'Question' } }
      let!(:search) { Search.new(search_params) }

      before do
        get :index, params: { search: search_params }, format: :js
      end

      it 'render index' do
        expect(response).to render_template :index
      end

      it 'populates an array' do
        expect(assigns(:search).results).to match_array(questions)
      end

      it 'assigns @search' do
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
