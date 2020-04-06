# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:question) { create(:question, :with_award, user: user) }
  let!(:answer) { create(:answer, question: question, user: user) }
  let!(:other_answer) { create(:answer, question: question, user: other_user) }
  before { login(user) }

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves a new answer for question in the database' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question }, format: :js }.to change(question.answers, :count).by(1)
      end

      it 'answer belongs to author' do
        post :create, params: { answer: attributes_for(:answer), question_id: question, format: :js }
        expect(question.answers.last.user_id).to eq(user.id)
      end

      it 'renders create template' do
        post :create, params: { answer: attributes_for(:answer), question_id: question, format: :js }
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer of question' do
        expect { post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }, format: :js }.to_not change(Answer, :count)
      end

      it 'renders create template' do
        post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question, format: :js }
        expect(response).to render_template :create
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'User tries to delete own answer' do
      it 'can to delete the answer' do
        expect { delete :destroy, params: { id: answer }, format: :js }.to change(Answer, :count).by(-1)
      end

      it 'render destroy template' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'User tries to delete not own answer' do
      before { sign_in(create(:user)) }

      it 'can not to delete the answer' do
        expect { delete :destroy, params: { id: answer }, format: :js }.to_not change(Answer, :count)
      end

      it 'render destroy template' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to render_template :destroy
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      it 'changes answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'new body' }, format: :js }
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        answer.reload
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      it 'does not change answer attributes' do
        expect do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        end.to_not change(answer, :body)
      end

      it 'renders update template' do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'User tries to update not own answer' do
      before { sign_in(create(:user)) }

      it 'does not change answer attributes' do
        old_body = answer.body
        patch :update, params: { id: answer, answer: { body: 'new body' }, format: :js }
        answer.reload
        expect(answer.body).to eq old_body
      end
    end
  end

  describe 'PATCH #best' do
    context 'user sets a best answer to own question' do
      it 'chooses the answer as the best' do
        patch :best, params: { id: answer }, format: :js
        answer.reload
        expect(answer).to be_best
      end

      it "assigns award to user's answer" do
        expect { patch :best, params: { id: answer }, format: :js }.to change(answer.user.awards, :count).by(1)
      end
    end

    context 'user tries to set a best answer to not own question' do
      before { sign_in(create(:user)) }

      it 'does not choose the answer as the best' do

        patch :best, params: { id: answer }, format: :js
        answer.reload
        expect(answer).not_to be_best
      end
    end
  end

  describe 'POST #up' do
    context 'user tries to create new up vote to answer of the question' do

      it 'creates a new up vote to not own answer' do
        expect { post :up, params: { id: other_answer }, format: :json }.to change(other_answer.votes, :count).by(1)
      end

      it 'creates a new up vote to not own answer' do
        expect { post :up, params: { id: answer }, format: :json }.to_not change(answer.votes, :count)
      end
    end
  end

  describe 'POST #down' do
    context 'user tries to creates new down vote to answer of the question' do

      it 'creates a new down vote to not own answer' do
        expect { post :down, params: { id: other_answer }, format: :json }.to change(other_answer.votes, :count).by(1)
      end

      it 'creates a new down vote to not own answer' do
        expect { post :down, params: { id: answer }, format: :json }.to_not change(answer.votes, :count)
      end
    end
  end
end
