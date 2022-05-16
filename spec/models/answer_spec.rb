require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question }
  it { should belong_to :user }
  it { should validate_presence_of :body }
  it { should have_many(:links).dependent(:destroy) }
  it { should accept_nested_attributes_for :links }

  it 'have many attached files' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
end

describe 'Check set_as_best model method' do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:default_answer) { create(:answer, question: question, user: user) }

  it 'retunrn false if answer is not the best' do
    expect(default_answer).to_not be_best
  end

  it 'retunrn true if answer is the best' do
    default_answer.set_as_best
    default_answer.reload
    expect(default_answer).to be_best
  end
end

#rspec spec/models/answer_spec.rb
