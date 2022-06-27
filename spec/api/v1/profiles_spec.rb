require 'rails_helper'

describe 'Profiles API', type: :request do
  let(:headers) { { "ACCEPT" => "application/json" } }
  describe 'GET /api/v1/profiles/me' do

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { '/api/v1/profiles/me' }
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id ) }

      before { get '/api/v1/profiles/me', params: { access_token: access_token.token }, headers: headers }
      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %w[id email admin created_at updated_at].each do |attr|
          expect(json['user'][attr]).to eq me.send(attr).as_json
        end
      end

      it 'does not return provate fields' do
        %w[password encrypted_password].each do |attr|
          expect(json['user']).to_not have_key(attr)
        end
      end
    end
  end

  describe 'GET api/v1/profiles' do

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { '/api/v1/profiles' }
    end

    context 'authorized' do
      let(:me) { create(:user)}
      let(:access_token) { create(:access_token, resource_owner_id: me.id ) }
      let!(:other_users) { create_list(:user, 5) }

      before { get '/api/v1/profiles', params: { access_token: access_token.token }, headers: headers }
      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns array with the same size as other users quantity' do
        expect(json['users'].size).to eq(other_users.size)
      end

      it 'returns only other users' do
        json['users'].each { |el| expect(el['id']).to_not eq me.id }
      end
    end
  end
end

# rspec spec/api/v1/profiles_spec.rb