require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  describe 'DELETE #destroy' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }

    let(:other_user) { create(:user) }
    let(:other_question) { create(:question, user: other_user) }

    before do
      question.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb')
    end

    it 'Unauthenticated user tries delete attached file' do
      expect { delete :destroy, params: { id: question.files.first.id }, format: :js }.not_to change(ActiveStorage::Attachment, :count)
    end

    context 'Authenticated user' do
      before { login(user) }

      it 'delete self-created attached file' do
        expect { delete :destroy, params: { id: question.files.first.id }, format: :js }.to change(question.files, :count).by(-1)
      end

      it 'cant delete attached file created by other user' do
        other_question.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb')
        expect { delete :destroy, params: { id: other_question.files.first.id }, format: :js }.not_to change(ActiveStorage::Attachment, :count)
      end
    end
  end
end

# rspec spec/controllers/attachments_controller_spec.rb
