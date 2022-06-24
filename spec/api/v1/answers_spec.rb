require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) { { 'ACCEPT' => 'application/json' } }

  describe 'GET /api/v1/questions/:question_id/answers' do
    let(:question) { create(:question) }
    let!(:answers) { create_list(:answer, 3, question: question) }
    let(:answer) { answers.first }
    let(:answer_response) { json['answers'].first }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns array of answers' do
        expect(json['answers'].size).to eq 3
      end

      it 'returns all public fields' do
        %w[id body question_id user_id created_at updated_at best].each do |attr|
          expect(answer_response[attr]).to eq answer.send(attr).as_json
        end
      end
    end
  end

  describe "GET /api/v1/answers/:id" do
    let(:answer) { create(:answer) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let!(:comments) { create_list(:comment, 3, commentable: answer, user: create(:user)) }
      let!(:links) { create_list(:link, 3, linkable: answer) }

      let!(:access_token) { create(:access_token) }
      let(:answer_response) { json['answer'] }

      before do
        answer.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb')
        answer.files.attach(io: File.open("#{Rails.root}/spec/spec_helper.rb"), filename: 'spec_helper.rb')

        get api_path, params: { access_token: access_token.token }, headers: headers
      end

      it 'return 200 status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %w[id body question_id user_id created_at updated_at best].each do |attr|
          expect(answer_response[attr]).to eq answer.send(attr).as_json
        end
      end

      it 'contains attachments object' do
        expect(answer_response['files'].count).to eq 2
      end

      it 'contains comments' do
        expect(answer_response['comments'].count).to eq 3
      end

      it 'contains links' do
        expect(answer_response['links'].count).to eq 3
      end
    end
  end
  
  describe 'POST /api/v1/questions/:id/answers' do
    let(:question) { create(:question) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
  
      describe 'with valid attributes' do
        it 'saves a new answer in the db' do
          expect { post api_path, params: { answer: attributes_for(:answer),
                                            access_token: access_token.token } }.to change(Answer, :count).by(1)
        end

        it 'returns status 201' do
          post api_path, params: { answer: attributes_for(:answer), access_token: access_token.token }
          expect(response.status).to eq 201
        end
      end

      describe 'with invalid attributes' do
        it 'not saves a new question in the db' do
          expect { post api_path, params: { answer: attributes_for(:answer, :invalid),
                                            access_token: access_token.token } }.to_not change(Answer, :count)
        end

        it 'returns status 422' do
          post api_path, params: { answer: attributes_for(:answer, :invalid), access_token: access_token.token }
          expect(response.status).to eq 422
        end

        it 'returns errors in json' do
          post api_path, params: { answer: attributes_for(:answer, :invalid), access_token: access_token.token }
          expect(json).to have_key('errors')
        end
      end
    end
  end

  describe "PATCH /api/v1/questions/:id" do
    let(:user) { create(:user) }
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, question: question, user: user) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
    end

    context 'authorized' do
      describe 'with valid attributes' do
        before do
          patch api_path, params: { answer: { body: 'chaged body' },
                                    access_token: access_token.token }
        end

        it 'returns status 200' do
          expect(response.status).to eq 200
        end

        it 'changes answer attributes' do
          answer.reload
          expect(answer.body).to eq 'chaged body'
        end
      end

      describe 'with invalid attributes' do
        before do
          patch api_path, params: { answer: { body: '' },
                                    access_token: access_token.token }
        end

        it 'returns errors in json' do
          expect(json).to have_key('errors')
        end

        it 'returns status 422' do
          expect(response.status).to eq 422
        end

        it 'not changes question attributes' do
          answer.reload
          expect(answer.body).to_not eq 'chaged body'
        end
      end
    end
  end

  describe "DELETE /api/v1/questions/:id" do
    let(:user) { create(:user) }
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, question: question, user: user) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
    end

    context 'authorized' do
      before do
        delete api_path, params: { access_token: access_token.token }
      end

      it 'returns status 200' do
        expect(response.status).to eq 200
      end

      it 'detroy answer from db' do
        expect(Answer.count).to eq 0
      end

      it 'returns successfully message' do
        expect(json['message']).to include 'Answer successfuly deleted'
      end
    end
  end
end

# rspec spec/api/v1/answers_spec.rb