require 'rails_helper'

RSpec.describe RewardsController, type: :controller do
  let(:user) { create(:user) }
  let(:rewards) { create_list(:reward, 3, user: user) }

  describe "GET #index" do
    before { login(user) }
    before { get :index }

    it 'populates an array of rewards' do
      expect(assigns(:rewards)).to match_array(rewards)
    end

    it "renders index view" do
      expect(response).to render_template :index
    end
  end
end

# rspec spec/controllers/rewards_controller_spec.rb