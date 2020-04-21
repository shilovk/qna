# frozen_string_literal: true

require 'rails_helper'

describe 'Profiles API', type: :request do
  let(:headers) do
    { 'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json' }
  end
  let(:method) { :get }
  let(:current_user) { create(:user) }
  let(:access_token) { create(:access_token, resource_owner_id: current_user.id) }
  let(:fields) { %w[id email admin created_at updated_at] }
  let(:private_fields) { %w[password encrypted_password] }

  describe 'GET /api/v1/profiles' do
    let(:api_path) { '/api/v1/profiles' }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let!(:users) { create_list(:user, 3) }
      let(:resource) { users.first }
      let(:resource_response) { json['users'].first }

      before do
        do_request method, api_path, params: { access_token: access_token.token }, headers: headers
      end

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all users except current' do
        expect(json['users'].count).to eq 3
      end

      it 'has not return resource' do
        json['users'].each do |user|
          expect(user['id']).to_not eq current_user.id
        end
      end

      include_examples 'API public fields returnable'

      include_examples 'API private fields returnable'
    end
  end

  describe 'GET /api/v1/profiles/me' do
    let(:api_path) { '/api/v1/profiles/me' }
    let(:resource) { current_user }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:resource_response) { json['user'] }

      before do
        do_request method, api_path, params: { access_token: access_token.token }, headers: headers
      end

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      include_examples 'API public fields returnable'

      include_examples 'API private fields returnable'
    end
  end
end
