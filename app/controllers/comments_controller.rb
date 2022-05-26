class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_resource, only: :create

  def create
    @comment = @resource.comments.new(comment_params)
    @comment.user = current_user
    @comment.save
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def set_resource
    if params[:question_id]
      @resource = Question.find(params[:question_id])
    elsif params[:answer_id]
      @resource = Answer.find(params[:answer_id])
    end
  end

end