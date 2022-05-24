require 'rails_helper'

shared_examples_for 'votable' do
  it { should have_many(:votes).dependent(:destroy) }

  let(:users) { create_list :user, 3 }
  let!(:model) { create described_class.name.downcase.to_sym }

  it 'check rank_up and rank methods' do
    users.each { |u| model.rank_up(u) }
    expect(model.rank).to eq (3)
  end

  it 'check rank_down and rank methods' do
    users.each { |u| model.rank_down(u) }
    expect(model.rank).to eq (-3)
  end

  it 'check rank_up canceling' do
    model.rank_up(users.first)
    expect(model.rank).to eq (1)
    model.rank_up(users.first)
    expect(model.rank).to eq (0)
  end

  it 'check rank_down canceling' do
    model.rank_down(users.first)
    expect(model.rank).to eq (-1)
    model.rank_down(users.first)
    expect(model.rank).to eq (0)
  end
end

# rspec spec/models