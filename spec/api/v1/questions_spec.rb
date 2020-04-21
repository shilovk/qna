# frozen_string_literal: true

require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) do
    { 'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json' }
  end
  let(:access_token) { create(:access_token) }

  describe 'GET /api/v1/questions' do
    let(:method) { :get }
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }

      before do
        do_request method, api_path, params: { access_token: access_token.token }, headers: headers
      end

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of questions' do
        expect(json['questions'].size).to eq 2
      end

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      it 'contains user object' do
        expect(question_response['user']['id']).to eq question.user.id
      end

      it 'contains short title' do
        expect(question_response['short_title']).to eq question.title.truncate(7)
      end
    end
  end # desc GET /api/v1/questions

  describe 'GET /api/v1/questions/:id' do
    let(:method) { :get }
    let!(:question) { create(:question, :with_files) }
    let(:api_path) { api_v1_question_path(question) }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:question_response) { json['question'] }
      let!(:comments) { create_list(:comment, 3, commentable: question) }
      let!(:links) { create_list(:link, 2, linkable: question) }

      before do
        do_request method, api_path, params: { access_token: access_token.token }, headers: headers
      end

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      context 'with resources' do
        let(:resource_response) { question_response }
        let(:files) { question.files }

        it_behaves_like 'API Linkable'
        it_behaves_like 'API Attachable'
        it_behaves_like 'API Commentable'
      end
    end
  end # desc GET /api/v1/questions/:id

  describe 'GET /api/v1/questions/:id/answers' do
    let(:method) { :get }
    let(:question) { create(:question, answers: create_list(:answer, 2)) }
    # let(:api_path) { api_v1_question_path(question) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:answer) { question.answers.first }
      let(:answer_response) { json['answers'].first }

      before do
        do_request method, api_path, params: { access_token: access_token.token }, headers: headers
      end

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all answers of the question' do
        expect(json['answers'].size).to eq 2
      end

      it 'returns all answer public fields' do
        %w[id body created_at updated_at].each do |attr|
          expect(answer_response[attr]).to eq answer.send(attr).as_json
        end
      end

      it 'contains answer\'s user object' do
        expect(answer_response['user']['id']).to eq answer.user.id
      end
    end
  end # desc GET /api/v1/questions/:id/answers
end
