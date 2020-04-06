# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user) { create(:user) }
  let!(:question) { create(:question, :with_file, user: user) }
  let!(:answer) { create(:answer, :with_file, user: user) }

  describe 'DELETE #destroy' do
    before { login(user) }

    context 'User tries tries to delete file on his resource' do
      it 'user deletes file on his question' do
        expect { delete :destroy, params: { id: question.files.first.id } }.to change(question.files, :count).by(-1)
      end

      it 'user deletes file on his answer' do
        expect { delete :destroy, params: { id: answer.files.first.id } }.to change(answer.files, :count).by(-1)
      end
    end

    context 'User tries tries to delete file on not his resource' do
      before { sign_in(create(:user)) }

      it 'user tries to delete file on not his question' do
        expect { delete :destroy, params: { id: question.files.first.id } }.to_not change(question.files, :count)
      end

      it 'user tries to delete file on not his answer' do
        expect { delete :destroy, params: { id: answer.files.first.id } }.to_not change(answer.files, :count)
      end
    end
  end
end
