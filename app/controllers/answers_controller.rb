class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: %i[create]
  before_action :find_answer, only: %i[update destroy set_best]
  after_action :publish_answer, only: %i[create]

  include Voted

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def update
    @answer.update(answer_params) if current_user.author_of?(@answer)
  end

  def set_best
    @question = @answer.question
    @answer.set_as_best if current_user.author_of?(@question)
  end

  def destroy
    @answer.destroy if current_user.author_of?(@answer)
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body,
                                   files: [],
                                   links_attributes: [:name, :url, :_destroy])
  end

  def publish_answer
    return if @answer.errors.any?

    ActionCable.server.broadcast(
        "answers_of_question_#{@answer.question.id}",
        @answer
    )
  end
end