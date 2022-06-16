require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) { { "CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json" } }

  describe 'GET /api/v1/questions' do

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { '/api/v1/questions' }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let(:question_responce) { json['questions'].first }
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
          expect(question_responce[attr]).to eq question.send(attr).as_json
        end
      end

      it 'contains user object' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_responce['user']['id']).to eq question.user.id
        end
      end

      it 'contains short title' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_responce['short_title']).to eq question.title.truncate(7)
        end
      end

      describe 'answers' do
        let(:answer) { answers.first }
        let(:answer_responce) { question_responce['answers'].first }

        it 'returns list of answers' do
          expect(question_responce['answers'].size).to eq 3
        end

        it 'returns all public fields' do
          %w[id body user_id created_at updated_at].each do |attr|
            expect(answer_responce[attr]).to eq answer.send(attr).as_json
          end
        end
      end
    end
  end
end

# rspec spec/api/v1/questions_spec.rb