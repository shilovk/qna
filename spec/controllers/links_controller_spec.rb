# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  let(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, user: user) }

  before do
    create(:link, linkable: question)
    create(:link, linkable: answer)
  end

  describe 'DELETE #destroy' do
    before { login(user) }

    context 'User tries to delete link on his resource' do
      it 'user deletes the link on his question' do
        expect { delete :destroy, params: { id: question.links.first.id } }.to change(question.links, :count).by(-1)
      end

      it 'user deletes the link on his answer' do
        expect { delete :destroy, params: { id: answer.links.first.id } }.to change(answer.links, :count).by(-1)
      end
    end

    context 'User tries to delete link on not his resource' do
      before { sign_in(create(:user)) }

      it 'user tries to delete link on not his question' do
        expect { delete :destroy, params: { id: question.links.first.id } }.to_not change(question.links, :count)
      end

      it 'user tries to delete link on not his answer' do
        expect { delete :destroy, params: { id: answer.links.first.id } }.to_not change(answer.links, :count)
      end
    end
  end
end
