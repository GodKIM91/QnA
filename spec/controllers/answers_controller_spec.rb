require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  before { login(user) }

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves a new answer in the db' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js } }.to change(question.answers, :count).by(1)
      end

      it 'renders create template' do
        post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js }
        expect(response).to render_template :create
      end
    end
    
    context 'with invalid attributes' do
      it 'does not save the answer in the db' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid), format: :js } }.to_not change(Answer, :count)
      end

      it 'renders create template' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid), format: :js }
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    let!(:answer) { create(:answer, question: question, user: user) }

    context 'Author tries edit answer with valid attributes' do
      before { login(user) }
      it 'changed answer body' do
        patch :update, params: { id: answer, answer: { body: 'changed body' } }, format: :js
        answer.reload
        expect(answer.body).to eq 'changed body'
      end

      it 'renders update template' do
        patch :update, params: { id: answer, answer: { body: 'changed body' } }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'Author tries edit answer with invalid attributes' do
      before { login(user) }
      it 'not change answer body' do
        expect { patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid), format: :js } }.to_not change(answer, :body)
      end

      it 'renders update template' do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'Not author tries to edit answer' do
      let(:other_user) { create(:user) }
      before{ login(other_user) }
      it 'not change answer body' do
        patch :update, params: { id: answer, answer: { body: 'changed body' } }, format: :js
        answer.reload
        expect(answer.body).to_not eq 'changed body'
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer, question: question, user: user) }
    let!(:other_user) { create(:user) }
    let!(:other_answer) { create(:answer, question: question, user: other_user) }

    before { login(user) }

    context 'Author tries' do
      it 'to delete self answer' do
        expect { delete :destroy, params: { id: answer }, format: :js }.to change(Answer, :count).by(-1)
      end

      it 'renders destroy template' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'Not author tries' do
      it 'to delete the answer' do
        expect { delete :destroy, params: { id: other_answer }, format: :js }.not_to change(Answer, :count)
      end
    end
  end

  describe 'PATCH #set_best' do
    let!(:answer) { create(:answer, question: question, user: user) }
    let(:other_user) { create(:user) }

    context "Author of question can choose best answer" do
      before { login(user) }

      it 'makes answer as best' do
        patch :set_best, params: { id: answer }, format: :js
        answer.reload
        expect(answer).to be_best
      end
    end

    context "Not author tries choose best answer" do
      before { login(other_user) }

      it "doesn't make answer as best" do
        patch :set_best, params: { id: answer }, format: :js
        answer.reload
        expect(answer).to_not be_best
      end
    end
  end
end