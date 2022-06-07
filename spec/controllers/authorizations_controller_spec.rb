require 'rails_helper'

RSpec.describe AuthorizationsController, type: :controller do

  describe 'POST #create' do
    before do
      allow(AuthorizationsMailer).to receive(:email_confirmation).and_return(Struct.new(:deliver_now).new)
    end

    context 'new user' do

      it 'creates new user in db with email from authorization_params' do
        expect { post :create, params: { authorization: { email: 'sample@vk.com', provider: 'vkontakte', uid: '123' } }
               }.to change(User, :count).by(1)

        user = User.last
        expect(user.email).to eq 'sample@vk.com'
      end

      it 'creates new unconfirmed authorization with provider and uid from authorization_params' do
        expect { post :create, params: { authorization: { email: 'sample@vk.com', provider: 'vkontakte', uid: '123' } }
               }.to change(Authorization, :count).by(1)

        authorization = Authorization.last
        expect(authorization.provider).to eq 'vkontakte'
        expect(authorization.uid).to eq '123'
        expect(authorization).not_to be_confirmed
      end
    end


    context 'user exists' do
      let!(:user) { create(:user) }

      it 'does not create user' do
        expect { post :create, params: { authorization: { email: user.email, provider: 'vkontakte', uid: '123' } }
               }.to_not change(User, :count)
      end

      context 'new authorization' do
        it 'creates new unconfirmed authorization with provider and uid from params' do
          expect { post :create, params: { authorization: { email: user.email, provider: 'vkontakte', uid: '123' } }
                 }.to change(Authorization, :count).by(1)

          authorization = Authorization.last
          expect(authorization.provider).to eq 'vkontakte'
          expect(authorization.uid).to eq '123'
          expect(authorization).not_to be_confirmed
          expect(authorization.user).to eq user
        end
      end

      context 'authorization exists' do
        let!(:authorization) { create(:authorization, user: user) }

        it 'does not create authorization' do
          expect { post :create, params: { authorization: { email: user.email, provider: authorization.provider, uid: authorization.uid } }
                 }.to_not change(Authorization, :count)
        end
      end
    end
  end


  describe 'GET #confirm_email' do
    let!(:user) { create(:user) }
    let!(:authorization) { create(:authorization, user: user) }

    before do
      get :confirm_email, params: { id: authorization }
    end

    it 'confirms authorization' do
      authorization.reload
      expect(authorization).to be_confirmed
    end

    it 'login user' do
      expect(subject.current_user).to eq authorization.user
    end

    it 'redirects to root path' do
      expect(response).to redirect_to root_path
    end
  end

end

# rspec spec/controllers/authorizations_controller_spec.rb