require 'rails_helper'

RSpec.describe Reward, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:user).optional }
  it { should validate_presence_of :title }
  it 'have many attached files' do
    expect(Reward.new.file).to be_an_instance_of(ActiveStorage::Attached::One)
  end
end

# rspec spec/models/reward_spec.rb
