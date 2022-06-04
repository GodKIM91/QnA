class CommentsChannel < ApplicationCable::Channel

  def follow(params)
    stream_from "comments_in_question_#{params['id']}"
  end
end