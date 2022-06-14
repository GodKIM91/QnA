class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_resource, only: :create
  after_action :publish_comment, only: :create

  authorize_resource

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
      @stream_obj_id = @resource.id
    elsif params[:answer_id]
      @resource = Answer.find(params[:answer_id])
      @stream_obj_id = @resource.question.id
    end
  end

  def publish_comment
    return if @comment.errors.any?

    ActionCable.server.broadcast(
        "comments_in_question_#{@stream_obj_id}",
        @comment
    )
  end

end