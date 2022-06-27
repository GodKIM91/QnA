require 'rails_helper'

shared_examples_for 'voted' do
  let(:author) { create :user }
  let(:voted_user) { create :user }
  let!(:author_model) { create(described_class.controller_name.classify.downcase.to_sym, user: author) }

  describe 'POST #like and #dislike by voted user' do
    before { login(voted_user) }

    context 'non-author can like' do
      it 'added vote in the db' do
        expect { patch :like, params: { id: author_model }, format: :json }.to change(Vote, :count).by(1)
      end

      it 'vote is vote if voted user' do
        patch :like, params: { id: author_model }, format: :json
        expect(Vote.last.user).to eq voted_user
      end

      it 'send json response' do
        patch :like, params: { id: author_model }, format: :json
        expect(response.header['Content-Type']).to include 'application/json'
      end
    end

    context 'non-author can dislike' do
      it 'added vote in the db' do
        expect { patch :dislike, params: { id: author_model }, format: :json }.to change(Vote, :count).by(1)
      end

      it 'vote is vote if voted user' do
        patch :dislike, params: { id: author_model }, format: :json
        expect(Vote.last.user).to eq voted_user
      end

      it 'send json response' do
        patch :dislike, params: { id: author_model }, format: :json
        expect(response.header['Content-Type']).to include 'application/json'
      end
    end
  end

  describe 'POST #like and #dislike by author' do
    before { login(author) }

    context 'author cant like' do
      it 'not added vote in the db' do
        expect { patch :like, params: { id: author_model }, format: :json }.to_not change(Vote, :count)
      end

      it 'send json response' do
        patch :like, params: { id: author_model }, format: :json
        expect(response.header['Content-Type']).to include 'application/json'
      end
    end

    context 'author cant dislike' do
      it 'not added vote in the db' do
        expect { patch :dislike, params: { id: author_model }, format: :json }.to_not change(Vote, :count)
      end

      it 'send json response' do
        patch :like, params: { id: author_model }, format: :json
        expect(response.header['Content-Type']).to include 'application/json'
      end
    end
  end
end

# rspec spec/controllers