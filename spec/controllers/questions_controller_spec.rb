# frozen_string_literal: true

require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:other_question) { create(:question, user: other_user) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 2, user: user) }
    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'assings the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'assings new answer for question' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'assings new link for answer' do
      expect(assigns(:answer).links.first).to be_a_new(Link)
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { login(user) }
    before { get :new }

    it 'assings a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'assings a new Question to @question' do
      expect(assigns(:question).links.first).to be_a_new(Link)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new question in the database' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end

      it 'question belongs to author' do
        post :create, params: { question: attributes_for(:question) }
        expect(question.user_id).to eq(user.id)
      end

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to question_path(Question.last.id)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, params: { question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
      end

      it 'renders new template' do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'POST #update' do
    before { login(user) }

    context 'with valid attributes' do
      it 'changes question attributes' do
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } }, format: :js
        question.reload

        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
      end

      it 'renders update template' do
        patch :update, params: { id: question, question: attributes_for(:question), format: :js }
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      before { patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js }
      it 'does not change question' do
        question.reload

        expect(question.title).to eq question.title
        expect(question.body).to eq 'MyText'
      end

      it 'renders update template' do
        expect(response).to render_template :update
      end
    end

    context 'User tries to update not own question' do
      before { sign_in(create(:user)) }

      it 'does not change question attributes' do
        old_body = question.body
        patch :update, params: { id: question, question: { body: 'new body' }, format: :js }
        question.reload
        expect(question.body).to eq old_body
      end
    end
  end

  describe 'DELETE #destroy' do
    before do
      login(user)
      question
    end

    context 'User tries to delete own question' do
      it 'deletes the question' do
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
      end

      it 'redirects to index view' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end

    context 'User tries to delete not own question' do
      before { sign_in(create(:user)) }

      it 'does not delete the question' do
        expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
      end

      it 'redirects to show view' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to question_path(question)
      end
    end
  end

  describe 'POST #up' do
    context 'user tries to create a new up vote to' do
      it 'creates a new up vote to not own question' do
        expect { post :up, params: { id: other_question.id }, format: :json }.to change(other_question.votes, :count).by(1)
      end

      it 'does not create a new up vote to own question' do
        expect { post :up, params: { id: question }, format: :json }.to_not change(question.votes, :count)
      end
    end
  end

  describe 'POST #down' do
    context 'user tries to create a new down vote to a question' do
      it 'creates a new down vote to not own question' do
        expect { post :down, params: { id: other_question }, format: :json }.to change(other_question.votes, :count).by(1)
      end

      it 'does not create a new down vote to own question' do
        expect { post :down, params: { id: question }, format: :json }.to_not change(question.votes, :count)
      end
    end
  end
end
