# frozen_string_literal: true

require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) do
    { 'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json' }
  end
  let(:access_token) { create(:access_token) }
  let(:fields) { %w[id title body created_at updated_at] }

  describe 'GET /api/v1/questions' do
    let(:method) { :get }
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let!(:questions) { create_list(:question, 2) }
      let(:resource) { questions.first }
      let(:resource_response) { json['questions'].first }

      before do
        do_request method, api_path, params: { access_token: access_token.token }, headers: headers
      end

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of questions' do
        expect(json['questions'].size).to eq 2
      end

      include_examples 'API public fields returnable'

      it 'contains user object' do
        expect(resource_response['user']['id']).to eq resource.user.id
      end

      it 'contains short title' do
        expect(resource_response['short_title']).to eq resource.title.truncate(7)
      end
    end
  end # desc GET /api/v1/questions

  describe 'GET /api/v1/questions/:id' do
    let(:method) { :get }
    let!(:resource) { create(:question, :with_files, :with_comments, :with_links) }
    let(:api_path) { api_v1_question_path(resource) }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:resource_response) { json['question'] }

      before do
        do_request method, api_path, params: { access_token: access_token.token }, headers: headers
      end

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      include_examples 'API public fields returnable'

      context 'with resources' do
        it_behaves_like 'API Linkable'
        it_behaves_like 'API Attachable'
        it_behaves_like 'API Commentable'
      end
    end
  end # desc GET /api/v1/questions/:id

  describe 'POST /api/v1/questions' do
    let(:method) { :post }
    let(:api_path) { api_v1_questions_path }

    it_behaves_like 'API Authorizable'

    context 'successful create' do
      let(:request_params) do
        { question: attributes_for(:question),
          access_token: access_token.token }
      end

      before do
        do_request method, api_path, params: request_params, headers: headers
      end

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      include_examples 'API public fields returnable' do
        let(:resource) { Question.last }
        let(:resource_response) { json['question'] }
        let(:fields) { %w[id title body created_at updated_at] }
      end
    end

    context 'tries to create with errors' do
      let(:request_params) do
        { access_token: access_token.token,
          question: attributes_for(:question, :invalid) }
      end

      before do
        do_request method, api_path, params: request_params, headers: headers
      end

      it 'return failed status' do
        expect(response.status).to eq 422
      end

      it 'return errors' do
        expect(json['errors']).to_not eq nil
      end
    end
  end # desc POST /api/v1/questions
end
