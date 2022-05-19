require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to :linkable }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  it { should allow_value('https://github.com/').for(:url) }
  it { should_not allow_value('something_wrong_url').for(:url) }

  describe "Check 'gist?' model method" do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:link) { create(:link, linkable: question) }
    let(:gist_link) { create(:link, :gist, linkable: question) }

    it 'true if gist-link' do
      expect(gist_link.gist?).to eq true
    end

    it 'false if not gist-link' do
      expect(link.gist?).to eq false
    end
  end
end

# rspec spec/models/link_spec.rb