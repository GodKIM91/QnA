require 'rails_helper'

RSpec.describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  describe 'for user' do
    let(:user) { create :user }
    let(:author) { create :user }

    let(:user_question) { create(:question, user: user) }
    let(:other_user_question) { create(:question, user: author) }

    let(:user_answer) { create(:answer, question: other_user_question, user: user) }
    let(:other_user_answer) { create(:answer, question: user_question, user: author) }

    # all
    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }
    
    # Questions
    it { should be_able_to :create, Question}
    it { should be_able_to :update, create(:question, user: user), user: user }
    it { should_not be_able_to :update, create(:question, user: author), user: user }
    it { should be_able_to :destroy, create(:question, user: user), user: user }
    it { should_not be_able_to :destroy, create(:question, user: author), user: user }

    # Answers
    it { should be_able_to :create, Answer}
    it { should be_able_to :update, create(:answer, user: user), user: user }
    it { should_not be_able_to :update, create(:answer, user: author), user: user }
    it { should be_able_to :destroy, create(:answer, user: user), user: user }
    it { should_not be_able_to :destroy, create(:answer, user: author), user: user }

    # Comments
    it { should be_able_to :create, Comment}

    # Attachments
    context 'Question attachments' do
      before do
        user_question.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb')
        other_user_question.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb')
      end
      it { should be_able_to :destroy, user_question.files.first, user: user }
      it { should_not be_able_to :destroy, other_user_question.files.first, user: user }
    end

    context 'Answer attachments' do
      before do
        user_answer.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb')
        other_user_answer.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb')
      end
      it { should be_able_to :destroy, user_answer.files.first, user: user }
      it { should_not be_able_to :destroy, other_user_answer.files.first, user: user }
    end

    # Links
    it { should be_able_to :destroy, create(:link, linkable: create(:question, user: user)), user: user }
    it { should_not be_able_to :destroy, create(:link, linkable: create(:question, user: author)), user: user }

    # Votes
    it { should be_able_to :like, create(:question, user: author), user: user }
    it { should_not be_able_to :like, create(:question, user: user), user: user }
  end

  describe 'for guest' do
    let(:user) { nil }
    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }
    it { should be_able_to :manage, :all }
  end
end

# rspec spec/models/ability_spec.rb