class QuestionsController < ApplicationController
  
  before_action :authenticate_user!, except: %i[index show]
  before_action :load_question, only: %i[show edit update destroy]
  after_action :publish_question, only: :create

  authorize_resource

  include Voted

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
    @answer.links.new
  end

  def new
    @question = current_user.questions.new
    @question.links.new
    @question.reward = Reward.new
  end

  def edit; end

  def create
    @question = current_user.questions.new(question_params)
    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    @question.update(question_params) if can?(:update, @question)
  end

  def destroy
    @question.destroy if can?(:destroy, @question)
    redirect_to questions_path, notice: 'Your question successfully deleted.'
  end

  private 

  def load_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title,
                                     :body, 
                                     files: [],
                                     links_attributes: [:name, :url,:_destroy],
                                     reward_attributes: [:title, :file])
  end

  def publish_question
    return if @question.errors.any?

    ActionCable.server.broadcast(
        'questions',
        ApplicationController.render(
            partial: 'questions/action_cable_partial',
            locals: { question: @question }
        )
    )
  end
end
