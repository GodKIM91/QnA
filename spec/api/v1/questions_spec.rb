require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) { { 'ACCEPT' => 'application/json' } }

  describe 'GET /api/v1/questions' do

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { '/api/v1/questions' }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }
      let!(:answers) { create_list(:answer, 3, question: question) }

      before { get '/api/v1/questions', params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns array of questions' do
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

      describe 'answers' do
        let(:answer) { answers.first }
        let(:answer_response) { question_response['answers'].first }

        it 'returns list of answers' do
          expect(question_response['answers'].size).to eq 3
        end

        it 'returns all public fields' do
          %w[id body user_id question_id created_at updated_at best].each do |attr|
            expect(answer_response[attr]).to eq answer.send(attr).as_json
          end
        end
      end
    end
  end

  describe "GET /api/v1/questions/:id" do
    let(:question) { create(:question) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let!(:answers) { create_list(:answer, 3, question: question) }
      let!(:comments) { create_list(:comment, 3, commentable: question, user: create(:user)) }
      let!(:links) { create_list(:link, 3, linkable: question) }

      let!(:access_token) { create(:access_token) }
      let(:question_response) { json['question'] }

      before do
        question.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb')
        question.files.attach(io: File.open("#{Rails.root}/spec/spec_helper.rb"), filename: 'spec_helper.rb')

        get api_path, params: { access_token: access_token.token }, headers: headers
      end

      it 'return 200 status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      it 'contains attachments object' do
        expect(question_response['files'].count).to eq 2
      end

      it 'contains short title' do
        expect(question_response['short_title']).to eq question.title.truncate(7)
      end

      it 'contains user object' do
        expect(question_response['user']['id']).to eq question.user.id
      end

      it 'contains comments' do
        expect(question_response['comments'].count).to eq 3
      end

      it 'contains answers' do
        expect(question_response['answers'].count).to eq 3
      end

      it 'contains links' do
        expect(question_response['links'].count).to eq 3
      end
    end
  end

  describe "POST /api/v1/questions" do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    context 'authorized' do
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }
  
      describe 'with valid attributes' do
        it 'saves a new question in the db' do
          expect { post api_path, params: { question: attributes_for(:question),
                                            access_token: access_token.token } }.to change(Question, :count).by(1)
        end

        it 'returns status 201' do
          post api_path, params: { question: attributes_for(:question), access_token: access_token.token }
          expect(response.status).to eq 201
        end
      end

      describe 'with invalid attributes' do
        it 'not saves a new question in the db' do
          expect { post api_path, params: { question: attributes_for(:question, :invalid),
                                            access_token: access_token.token } }.to_not change(Question, :count)
        end

        it 'returns status 422' do
          post api_path, params: { question: attributes_for(:question, :invalid), access_token: access_token.token }
          expect(response.status).to eq 422
        end

        it 'returns errors in json' do
          post api_path, params: { question: attributes_for(:question, :invalid), access_token: access_token.token }
          expect(json).to have_key('errors')
        end
      end
    end
  end

  describe "PATCH /api/v1/questions/:id" do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
    end

    context 'authorized' do
      describe 'with valid attributes' do
        before do
          patch api_path, params: { question: { title: 'changed title', body: 'chaged body' },
                                    access_token: access_token.token }
        end

        it 'returns status 200' do
          expect(response.status).to eq 200
        end

        it 'changes question attributes' do
          question.reload
          expect(question.title).to eq 'changed title'
          expect(question.body).to eq 'chaged body'
        end
      end

      describe 'with invalid attributes' do
        before do
          patch api_path, params: { question: { title: '', body: 'changed body' },
                                    access_token: access_token.token }
        end

        it 'returns errors in json' do
          expect(json).to have_key('errors')
        end

        it 'returns status 422' do
          expect(response.status).to eq 422
        end

        it 'not changes question attributes' do
          question.reload
          expect(question.body).to_not eq 'chaged body'
        end
      end
    end
  end
  
  describe "DELETE /api/v1/questions/:id" do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
    end

    it_behaves_like 'API Deletable' do
      let(:klass) { 'Question' }
    end
  end
end

# rspec spec/api/v1/questions_spec.rb