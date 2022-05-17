require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  describe 'DELETE #destroy' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let!(:link) { create(:link, linkable: question) }
    let(:other_user) { create(:user) }
    let(:other_question) { create(:question, user: other_user) }
    let!(:other_link) { create(:link, linkable: other_question) }


    it 'Unauthenticated user tries delete link' do
      expect { delete :destroy, params: { id: link.id }, format: :js }.not_to change(question.links, :count)
    end

    context 'Authenticated user' do
      before { login(user) }

      it 'delete self-created attached link' do
        expect { delete :destroy, params: { id: link.id }, format: :js }.to change(question.links, :count).by(-1)
      end

      it 'cant delete attached link created by other user' do
        expect { delete :destroy, params: { id: other_link.id }, format: :js }.not_to change(other_question.links, :count)
      end
    end
  end
end

# rspec spec/controllers/links_controller_spec.rb
