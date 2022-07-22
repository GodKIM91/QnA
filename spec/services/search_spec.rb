# require 'rails_helper'

# RSpec.describe SearchService, elasticsearch: true do
#   let!(:user) { create(:user) }

#   before do
#     @user = create(:user, email: 'body@gmail.com', password: '123456', password_confirmation: '123456')
#     @question = create(:question, title: 'title 1', body: 'body 1', user: @user)
#     @answer = create(:answer, question: @question, body: 'body 2')
#     @comment = create(:comment, commentable: @question, body: 'body 3', user: @user)
#     [Question, Answer, Comment, User].each do |model|
#       model.__elasticsearch__.delete_index!
#       model.__elasticsearch__.create_index!
#       model.__elasticsearch__.import
#       model.__elasticsearch__.refresh_index!
#     end
#   end

#   describe 'search all models' do
#     before do
#       @results = SearchService.new.search('body', 'All')
#     end

#     it 'returns array of results' do
#       expect(@results).to be_an_instance_of(Array)
#       expect(@results.size).to eq 4
#     end
#   end

#   describe 'search only one model' do
#     describe 'question' do
#       before { @results = SearchService.new.search(@question.title, "Question") }

#       it 'returns array of results' do
#         expect(@results.size).to eq 1
#       end

#       it 'should return only questions' do
#         expect(@results.first[:title]).to eq(@question.title)
#         expect(@results.first[:details]).to eq(@question.body)
#         expect(@results.first[:id]).to eq(@question.id)
#       end
#     end

#     describe 'answer' do
#       before { @results = SearchService.new.search(@answer.body, "Answer") }

#       it 'returns array of results' do
#         expect(@results.size).to eq 1
#       end

#       it 'should return only answers' do
#         expect(@results.first[:title]).to eq(@answer.question.title)
#         expect(@results.first[:details]).to eq(@answer.body)
#         expect(@results.first[:id]).to eq(@answer.id)
#       end
#     end

#     describe 'comment' do
#       before { @results = SearchService.new.search(@comment.body, "Comment") }

#       it 'returns array of results' do
#         expect(@results.size).to eq 1
#       end

#       it 'should return only comments' do
#         expect(@results.first[:title]).to eq(@comment.commentable.title)
#         expect(@results.first[:details]).to eq(@comment.body)
#         expect(@results.first[:id]).to eq(@comment.id)
#       end
#     end

#     describe 'user' do
#       before { @results = SearchService.new.search(@user.email, "User") }

#       it 'returns array of results' do
#         expect(@results.size).to eq 1
#       end

#       it 'should return only comments' do
#         expect(@results.first[:title]).to eq(@user.email)
#         expect(@results.first[:details]).to eq(@user.email)
#         expect(@results.first[:id]).to eq(@user.id)
#       end
#     end
#   end
# end

# # rspec spec/services/search_spec.rb
