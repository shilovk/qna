# frozen_string_literal: true

require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) do
    { 'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json' }
  end
  let(:access_token) { create(:access_token) }
  let(:fields) { %w[id body created_at updated_at] }

  describe 'GET /api/v1/questions/:id/answers' do
    let(:method) { :get }
    let(:question) { create(:question, answers: create_list(:answer, 2)) }
    let(:api_path) { api_v1_question_answers_path(question) }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:resource) { question.answers.first }
      let(:resource_response) { json['answers'].first }

      before do
        do_request method, api_path, params: { access_token: access_token.token }, headers: headers
      end

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all answers of the question' do
        expect(json['answers'].size).to eq 2
      end

      include_examples 'API public fields returnable'

      it 'contains answer\'s question object' do
        expect(resource_response['question']['id']).to eq resource.question.id
      end

      it 'contains answer\'s user object' do
        expect(resource_response['user']['id']).to eq resource.user.id
      end
    end
  end # desc GET /api/v1/questions/:id/answers

  describe 'GET /api/v1/answers/:id' do
    let(:method) { :get }
    let!(:resource) { create(:answer, :with_files, :with_comments, :with_links) }
    let(:api_path) { api_v1_answer_path(resource) }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:resource_response) { json['answer'] }

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
  end # desc GET /api/v1/answers/:id
end
