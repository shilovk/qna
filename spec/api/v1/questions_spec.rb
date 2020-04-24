# frozen_string_literal: true

require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) do
    { 'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json' }
  end
  let(:current_user) { create(:user) }
  let(:access_token) { create(:access_token, resource_owner_id: current_user.id) }
  let(:fields) { %w[id title body created_at updated_at] }

  describe 'GET /api/v1/questions' do
    let(:method) { :get }
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let!(:questions) { create_list(:question, 2) }
      let(:resource) { questions.first }
      let(:resource_response) { json['questions'].last }

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

    describe 'authorize' do
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
    end
  end # desc POST /api/v1/questions

  describe 'PATCH /api/v1/questions/:id' do
    let(:method) { :patch }
    let!(:question) { create(:question, user: current_user) }
    let(:api_path) { api_v1_question_path(question) }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:request_params) do
        { question: attributes_for(:question),
          access_token: access_token.token }
      end

      before do
        do_request method, api_path, params: request_params, headers: headers
        question.reload
      end

      it 'returns success status' do
        expect(response).to be_successful
      end

      it 'unset attributes not be blank' do
        expect(json['question']['body']).to_not be_empty
      end

      include_examples 'API fields updatable' do
        let(:resource) { Question.find(question.id) }
        let(:resource_request_params) { request_params[:question] }
        let(:update_fields) { %w[title body] }
      end

      include_examples 'API public fields returnable' do
        let(:resource) { Question.find(question.id) }
        let(:resource_response) { json['question'] }
        let(:fields) { %w[id title body created_at updated_at] }
      end
    end
  end # PATCH /api/v1/questions/:id

  describe 'DELETE /api/v1/questions/:id' do
    let(:method) { :delete }
    let!(:question) { create(:question, user: current_user) }
    let(:api_path) { api_v1_question_path(question) }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:request_params) do
        { access_token: access_token.token }
      end

      before do
        do_request method, api_path, params: request_params, headers: headers
      end

      it 'returns success status' do
        expect(response).to be_successful
      end

      it 'question not found' do
        expect { Question.find(question.id) }.to raise_error(ActiveRecord::RecordNotFound)
      end

      include_examples 'API public fields returnable' do
        let(:resource) { question }
        let(:resource_response) { json['question'] }
        let(:fields) { %w[title body created_at updated_at] }
      end
    end
  end # DELETE /api/v1/questions/:id
end
