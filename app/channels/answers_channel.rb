class AnswersChannel < ApplicationCable::Channel

  def follow(params)
    stream_from "answers_of_question_#{params['id']}"
  end
end