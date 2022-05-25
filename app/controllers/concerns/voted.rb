require 'active_support/concern'

module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: [:like, :dislike]
  end

  def like
    @votable.rank_up(current_user) if !current_user.author_of?(@votable)
    render_json_respond
  end

  def dislike
    @votable.rank_down(current_user) if !current_user.author_of?(@votable)
    render_json_respond
  end

  private

  def set_votable
    @votable = controller_name.classify.constantize.find(params[:id])
  end

  def render_json_respond
    respond_to do |format|
      format.json { render json: @votable.rank }
    end
  end
end